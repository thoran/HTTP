# Hash/x_www_form_urlencode.rb
# Hash#x_www_form_urlencode

# 20130310
# 0.0.0

# Notes: Extracted from MtGox library.  

# Todo: 
# 1. I should separate out the functionality for adding '+' characters so as it can do both styles of encoding.  That way I could reuse the existing Hash/to_parameter_string method as well...  

require 'String/url_encode'

class Hash

  def x_www_form_urlencode(joiner = '&')
    inject([]){|a,e| a << "#{e.first.to_s.url_encode.gsub(/ /, '+')}=#{e.last.to_s.url_encode.gsub(/ /, '+')}" unless e.last.nil?; a}.join(joiner)
  end

end
