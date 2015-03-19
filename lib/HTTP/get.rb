# HTTP#get

# 20120611
# 0.5.1

# Changes since 0.4: 
# 0 (Removed Mechanize, since it wasn't working properly, but did 'retain' Nokogiri.)
# 1. - require 'MechanizeHelper.rbd/MechanizeHelper'.  
# 2. + require 'Hash/to_parameter_string'.  
# 3. + require 'nokogiri'.  
# 0/1 (Added the bare minimum of encoding support.)
# 4. Added UTF-8 encoding to Nokogiri's parser.  
# 5. /Nokogiri::HTML/Nokogiri::HTML.parse/.  

require 'Hash/to_parameter_string'
require 'net/http'
require 'nokogiri'
require 'uri'

module HTTP
  
  def get(url, params = {}, encoding = 'UTF-8')
    uri = URI.parse(url)
    path = params.empty? ? uri.path : "#{uri.path}?#{params.to_parameter_string}"
    body = Net::HTTP.get(uri.host, path, uri.port)
    page = Nokogiri::HTML.parse(body, url, encoding)
    if block_given?
      yield page
    else
      page
    end
  end
  
end
