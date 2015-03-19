# HTTP/post.rb
# HTTP#post.rb

# 20130307
# 0.8.1

# Changes: 
# 1. The parameter, data, can now also accept a :header argument which contains a hash of key-value pairs to be set as part of the header for the request.  

# Notes: This doesn't return a MechanizeHelper::Page as was intended by the others, but it does work...  (Will get to the MechanizeHelper::Page version later.)

require '_meta/blankQ'
require 'net/http'
require 'uri'

module URI
  class HTTP

    def interpolated_port
      scheme == 'https' ? 443 : 80
    end

    def use_ssl?
      scheme == 'https' ? true : false
    end

  end
end

module HTTP

  def post(uri, data)
    uri_object = URI.parse(uri)
    http = Net::HTTP.new(uri_object.host, uri_object.port || uri_object.default_port)
    http.use_ssl = uri_object.use_ssl?
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request_object = Net::HTTP::Post.new(uri_object.request_uri)
    if header = data.delete(:header)
      header.each{|k,v| request_object[k] = v}
    end
    request_object.set_form_data(data)
    response = http.request(request_object)
    response.body
  end

  module_function :post

end

if __FILE__ == $0
  url = "http://w3schools.com/asp/demo_simpleform.asp"
  args = {fname: 'thoran'}
  puts HTTP.post(url, args)
end
