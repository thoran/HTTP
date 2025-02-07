# HTTP/post.rb
# HTTP.post

require 'json'
require 'net/http'
require 'openssl'
require 'uri'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'HTTP/get'
require 'Net/HTTP/set_options'
require 'Net/HTTP/Post/set_headers'
require 'URI/Generic/use_sslQ'

module HTTP

  def post(uri, data = {}, headers = {}, options = {}, &block)
    uri = uri.is_a?(URI) ? uri : URI.parse(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    options[:use_ssl] ||= uri.use_ssl?
    options[:verify_mode] ||= OpenSSL::SSL::VERIFY_NONE
    http.options = options
    request_object = Net::HTTP::Post.new(uri.request_uri)
    if headers['Content-Type'] == 'application/json'
      request_object.body = JSON.dump(data)
    else
      request_object.form_data = data
    end
    request_object.headers = headers
    request_object.basic_auth(uri.user, uri.password) if uri.user
    response = http.request(request_object)
    if response.code =~ /^3/
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

  module_function :post

end
