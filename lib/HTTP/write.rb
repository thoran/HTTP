# HTTP/write.rb
# HTTP#write

# 20150319
# 0.1.0

# Description: Rather than using HTTP.get then having to separately write the file, just use HTTP.write and specify the url and optionally the local path.

# Changes:
# 1. It actually makes use of the local_path variable now.

require 'File/self.write'
require 'HTTP/get'
require 'URI/Generic/pathname'

module HTTP

  def write(url, local_path = nil)
    local_path = local_path || URI.parse(url).pathname.basename
    contents = HTTP.get(url).body
    File.write(local_path, contents)
  end

  module_function :write

end
