# HTTP/write.rb
# HTTP#write

# 20130622
# 0.0.0

# Description: Rather than using HTTP.get then having to separately write the file, just use HTTP.write and specify the url and optionally the local path.  

require 'File/self.write'
require 'HTTP/get'
require 'URI/Generic/pathname'

module HTTP

  def write(url, local_path = nil)
    local_path = local_path || URI.parse(url).pathname.basename
    File.write(URI.parse(url).pathname.basename, HTTP.get(url).body)
  end

  module_function :write

end
