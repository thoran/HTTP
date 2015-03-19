# HTTP.rb
# HTTP

# 20150304, 10, 18
# 0.10.0

# Changes since 0.9:
# 1. + HTTP.gemspec.
# 2. + dependencies.
# 3. + Gemfile.
# 4. + specs.
# 5. + lib/HTTP.rb.

lib_dir = File.expand_path(File.join(__FILE__, '..'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'HTTP/get'
require 'HTTP/post'
