# HTTP/get.rb
# HTTP.get

require 'net/http'
require 'openssl'
require 'uri'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'Hash/x_www_form_urlencode'
require 'Net/HTTP/set_options'
require 'Net/HTTP/Get/set_headers'
require 'Net/HTTPResponse/StatusPredicates'
require 'URI/Generic/use_sslQ'

module HTTP

  def get(uri, args = {}, headers = {}, options = {}, &block)
    uri = uri.is_a?(URI) ? uri : URI.parse(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    no_redirect = options.delete(:no_redirect)
    options[:use_ssl] ||= uri.use_ssl?
    options[:verify_mode] ||= OpenSSL::SSL::VERIFY_NONE
    http.options = options
    request_object = Net::HTTP::Get.new(uri.request_uri + '?' + args.x_www_form_urlencode)
    request_object.headers = headers
    request_object.basic_auth(uri.user, uri.password) if uri.user
    response = http.request(request_object)
    if response.code =~ /^3/
      if block_given? && no_redirect
        yield response
      elsif no_redirect
        return response
      end
      redirect_uri = URI.parse(response.header['location'])
      if redirect_uri.scheme
        response = get(response.header['location'], {}, {}, options, &block)
      else
        new_location = "http://#{uri.host}:#{uri.port}#{response.header['location']}"
        response = get(new_location, {}, {}, options, &block)
      end
    end
    if block_given?
      yield response
    else
      response
    end
  end

  module_function :get

end
