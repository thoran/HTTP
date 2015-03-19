# Net/HTTP/Post/set_headers.rb
# Net::HTTP::Post#set_headers

# 20130309
# 0.0.0

# Notes:
# 1. Using the date from when first created in HTTP.get/post as the creation date.

class Net::HTTP::Post

  def set_headers(headers = {})
    headers.each{|k,v| self[k] = v}
  end
  alias_method :headers=, :set_headers

end
