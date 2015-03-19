# HTTP/post.rb
# HTTP.post

# 20141029
# 0.9.4

# Changes since 0.8:
# 1. Can handle blocks as was the case up to 0.7.0, or pre 0.8.5 anyway.
# 0/1
# 2. ~ #post so as it can handle options for the http object.
# 1/2
# 3. Version number bump to match the change to HTTP.get.
# 2/3
# 4. + require 'openssl', since it seems to explicitly need to be required as of Ruby 2 somewhere.
# 3/4
# 5. Enabled Basic authentication to be automatically applied if there is a username and password in the supplied uri.

require 'net/http'
require 'openssl'
require 'uri'

module URI
  class HTTP

    def use_ssl?
      scheme == 'https' ? true : false
    end

  end
end

class Net::HTTP::Post

  def set_headers(headers = {})
    headers.each{|k,v| self[k] = v}
  end
  alias_method :headers=, :set_headers

end

module HTTP

  def post(uri, form_data = {}, headers = {}, options = {})
    uri = URI.parse(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = options[:use_ssl] || uri.use_ssl?
    http.verify_mode = options[:verify_mode] || OpenSSL::SSL::VERIFY_NONE
    options.each{|k,v| http.send("#{k}=", v)}
    request_object = Net::HTTP::Post.new(uri.request_uri)
    request_object.form_data = form_data
    request_object.headers = headers
    request_object.basic_auth(uri.user, uri.password) if uri.user
    response = http.request(request_object)
    if block_given?
      yield response
    else
      response
    end
  end

  module_function :post

end

if __FILE__ == $0
  url = "http://w3schools.com/asp/demo_simpleform.asp"
  args = {fname: 'thoran'}
  puts HTTP.post(url, args)
end
