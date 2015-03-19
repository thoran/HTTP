# spec/HTTP.rb

spec_dir = File.expand_path(File.join(__FILE__, '..'))
$LOAD_PATH.unshift(spec_dir) unless $LOAD_PATH.include?(spec_dir)

require 'spec_helper'

require 'HTTP/get'
require 'HTTP/post'

require 'HTTP/get_spec'
require 'HTTP/post_spec'
