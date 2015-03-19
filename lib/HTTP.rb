# HTTP.rb
# HTTP

# 20150319
# 0.11.0

# Changes since 0.10:
# 1. Removed HTTP/write.rb, since I wanted to reimplement it using standard File methods and not my custom written File.write.  It may stay gone, but I'm not sure yet...
# 2. + HTTP.gemspec
# 3. + README.md

lib_dir = File.expand_path(File.join(__FILE__, '..'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'HTTP/get'
require 'HTTP/post'
