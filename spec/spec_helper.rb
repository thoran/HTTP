# spec/spec_helper.rb

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'webmock/rspec'
WebMock.allow_net_connect!

require 'fakefs/safe'
