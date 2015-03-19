# HTTP#get

# 20120610
# 0.5.0

# Changes since 0.4: 
# 0 (Removed Mechanize, since it wasn't working properly, but did 'retain' Nokogiri.)
# 1. - require 'MechanizeHelper.rbd/MechanizeHelper'.  
# 2. + require 'Hash/to_parameter_string'.  
# 3. + require 'nokogiri'.  

require 'Hash/to_parameter_string'
require 'net/http'
require 'nokogiri'
require 'uri'

module HTTP
  
  def get(url, params = {})
    uri = URI.parse(url)
    path = params.empty? ? uri.path : "#{uri.path}?#{params.to_parameter_string}"
    body = Net::HTTP.get(uri.host, path, uri.port)
    page = Nokogiri::HTML(body)
    if block_given?
      yield page
    else
      page
    end
  end
  
end
