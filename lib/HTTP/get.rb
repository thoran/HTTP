# HTTP/get.rb
# HTTP.get

require 'net/http'
require 'openssl'
require 'uri'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'Hash/x_www_form_urlencode'
require 'Net/HTTP/Get/set_headers'
require 'URI/Generic/use_sslQ'

module HTTP

  def get(uri, args = {}, headers = {}, options = {}, &block)
    uri = uri.is_a?(URI) ? uri : URI.parse(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = options[:use_ssl] || uri.use_ssl?
    http.verify_mode = options[:verify_mode] || OpenSSL::SSL::VERIFY_NONE
    options.each{|k,v| http.send("#{k}=", v)}
    request_object = Net::HTTP::Get.new(uri.request_uri + '?' + args.x_www_form_urlencode)
    request_object.headers = headers
    request_object.basic_auth(uri.user, uri.password) if uri.user
    response = http.request(request_object)
    if response.code =~ /^3/
      response = get(response.header['location'], {}, {}, options, &block)
    end
    if block_given?
      yield response
    else
      response
    end
  end

  module_function :get

end
