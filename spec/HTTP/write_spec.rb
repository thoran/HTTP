# spec/HTTP/write_spec.rb

spec_dir = File.expand_path(File.join(__FILE__, '..', '..'))
$LOAD_PATH.unshift(spec_dir) unless $LOAD_PATH.include?(spec_dir)

require 'fileutils'
require 'spec_helper'
require 'HTTP/write'

WebMock.enable!
WebMock.disable_net_connect!(allow_localhost: true)

describe ".write" do

  context "path supplied" do
    let(:path){'path'}
    let(:uri){"http://example.com/#{path}"}

    before do
      stub_request(:get, uri).
        with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(status: 200, body: 'body for path supplied', headers: {})
      HTTP.write(uri)
    end

    it "creates a new file with the basename of the supplied URI's path" do
      expect(Pathname.new(path).exist?).to be_truthy
    end

    it "creates a new file with the basename of the supplied URI's path with the body of the HTTP response" do
      expect(File.read(path)).to eq('body for path supplied')
    end

    after do
      FileUtils.rm(path)
    end
  end

  context "no path supplied" do
    let(:uri){'http://example.com'}
    let(:local_path){'test.txt'}

    before do
      stub_request(:get, uri).
        with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(status: 200, body: 'body for no path supplied', headers: {})
      HTTP.write(uri, local_path)
    end

    it "creates a new file with the supplied name" do
      expect(Pathname.new(local_path).exist?).to be_truthy
    end

    it "creates a new file with the basename of the supplied URI's path with the body of the HTTP response" do
      expect(File.read(local_path)).to eq('body for no path supplied')
    end

    after do
      FileUtils.rm(local_path)
    end
  end

end
