# HTTP/get
# HTTP#get

# 20130310
# 0.8.5

# Changes since 0.7: 
# 1. Changed from using Mechanize and MechanizeHelper to using standard Ruby library objects.  
# 2. Version number bump to be consistent with HTTP.post.  

require 'net/http'
require 'uri'

module URI
  class HTTP

    def use_ssl?
      scheme == 'https' ? true : false
    end

  end
end

class Net::HTTP::Get

  def set_headers(headers = {})
    headers.each{|k,v| self[k] = v}
  end
  alias_method :headers=, :set_headers

end

module HTTP

  def get(uri, args = {}, headers = {})
    uri = URI.parse(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.use_ssl?
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request_object = Net::HTTP::Get.new(uri.request_uri)
    request_object.headers = headers
    response = http.request(request_object)
    response
  end

  module_function :get

end
