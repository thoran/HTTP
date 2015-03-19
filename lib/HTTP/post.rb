# HTTP/post.rb
# HTTP#post.rb

# 20130310
# 0.8.5

# Changes: 
# 1. The parameter, data, can now also accept a :header argument which contains a hash of key-value pairs to be set as part of the header for the request.  
# 1/2
# 2. /header/headers/.  
# 2/3
# 3. Headers are now set via a separate parameter, since it is possible that form data may include the key 'headers'!  
# 4. - URI::HTTP.interpolated_port.  
# 3/4
# 5. + Net::HTTP::Post#set_headers.  
# 4/5
# 6. It now returns the response object and not the body of the response object.  

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
    response
  end

  module_function :post

end

if __FILE__ == $0
  url = "http://w3schools.com/asp/demo_simpleform.asp"
  args = {fname: 'thoran'}
  puts HTTP.post(url, args)
end
