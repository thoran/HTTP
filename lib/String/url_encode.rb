# String/url_encode.rb
# String#url_encode

# 20130310
# 0.2.1

# Description: When I went looking for a means to url encode and decode strings, I wanted something which used extensions to the String class.  Of course there are other means to do url encoding and decoding including using the CGI class, but I liked the approach of having this 'built-in' to strings, rather than the string being passed as a parameter as does CGI.  Hence this String extender...  

# Acknowledgements: I've simply ripped off and refashioned the code from the CGI module!...  

# Changes since 0.1:
# 1. The url_encode and url_decode methods now are strictly demarcated.  
# 0/1
# 2. A small reformat.  

class String

  def url_encode
    self.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
      '%' + $1.unpack('H2' * $1.size).join('%').upcase
    end.tr(' ', '+')
  end

end
