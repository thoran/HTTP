# HTTP/post.rb
# HTTP.post

require 'net/http'
require 'openssl'
require 'uri'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'HTTP/get'
require 'Net/HTTP/Post/set_headers'
require 'URI/Generic/use_sslQ'

module HTTP

  def post(uri, form_data = {}, headers = {}, options = {}, &block)
    uri = uri.is_a?(URI) ? uri : URI.parse(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = options[:use_ssl] || uri.use_ssl?
    http.verify_mode = options[:verify_mode] || OpenSSL::SSL::VERIFY_NONE
    options.each{|k,v| http.send("#{k}=", v)}
    request_object = Net::HTTP::Post.new(uri.request_uri)
    request_object.form_data = form_data
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

  module_function :post

end
