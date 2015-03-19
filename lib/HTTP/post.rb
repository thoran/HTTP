# HTTP/post.rb
# HTTP.post

# 20130320
# 0.9.0

# Changes since 0.8: 
# 1. Can handle blocks as was the case up to 0.7.0, or pre 0.8.5 anyway.  

# Notes: This doesn't return a MechanizeHelper::Page as was intended by the others, but it does work...  (Will get to the MechanizeHelper::Page version later.)  

require 'net/http'
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

  def post(uri, form_data = {}, headers = {})
    uri = URI.parse(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.use_ssl?
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request_object = Net::HTTP::Post.new(uri.request_uri)
    request_object.form_data = form_data
    request_object.headers = headers
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
