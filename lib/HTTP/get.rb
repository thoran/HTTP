# HTTP/get.rb
# HTTP.get

# 20130320
# 0.9.0

# Changes since 0.8: 
# 1. Can handle blocks as was the case up to 0.7.0, or pre 0.8.5 anyway.  

require 'net/http'
require 'uri'
require 'Hash/x_www_form_urlencode'

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
    request_object = Net::HTTP::Get.new(uri.request_uri + '?' + args.x_www_form_urlencode)
    request_object.headers = headers
    response = http.request(request_object)
    if block_given?
      yield response
    else
      response
    end
  end

  module_function :get

end
