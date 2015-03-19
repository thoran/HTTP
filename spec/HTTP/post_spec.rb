# spec/HTTP/post_spec.rb

spec_dir = File.expand_path(File.join(__FILE__, '..', '..'))
$LOAD_PATH.unshift(spec_dir) unless $LOAD_PATH.include?(spec_dir)

require 'spec_helper'
require 'HTTP/post'

WebMock.enable!
WebMock.disable_net_connect!(allow_localhost: true)

describe ".post" do

  context "with uri-only supplied" do
    before do
      stub_request(:post, 'http://example.com/path').
        with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(status: 200, body: '', headers: {})
    end

    context "uri as a string" do
      let(:uri){'http://example.com/path'}
      let(:parsed_uri){URI.parse(uri)}
      let(:net_http_object){Net::HTTP.new(parsed_uri.host, parsed_uri.port)}

      it "creates an instance of URI" do
        expect(URI).to receive(:parse).with(uri).and_return(parsed_uri)
        HTTP.post(uri)
      end

      it "creates a new Net::HTTP object" do
        expect(Net::HTTP).to receive(:new).with(parsed_uri.host, parsed_uri.port).and_return(net_http_object)
        HTTP.post(uri)
      end
    end

    context "uri as a URI" do
      let(:uri_string){'http://example.com/path'}
      let(:uri){URI.parse(uri_string)}
      let(:net_http_object){Net::HTTP.new(uri.host, uri.port)}

      it "returns an instance of URI" do
        expect(uri).to eq(uri)
        HTTP.post(uri)
      end

      it "creates a new Net::HTTP object" do
        expect(Net::HTTP).to receive(:new).with(uri.host, uri.port).and_return(net_http_object)
        HTTP.post(uri)
      end
    end
  end

  context "with form data supplied" do
    let(:uri){'http://example.com/path'}
    let(:parsed_uri){URI.parse(uri)}
    let(:form_data) do; {a: 1, b: 2}; end
    let(:encoded_form_data) do; form_data.x_www_form_urlencode; end
    let(:request_uri){parsed_uri.request_uri}
    let(:request_object){Net::HTTP::Post.new(request_uri)}

    before do
      stub_request(:post, "http://example.com/path").
        with(body: {"a"=>"1", "b"=>"2"}, headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(status: 200, body: '', headers: {})
    end

    it "sets the form data" do
      allow(Net::HTTP::Post).to receive(:new).with(request_uri).and_return(request_object)
      HTTP.post(uri, form_data)
      expect(request_object.body).to eq(encoded_form_data)
    end

    it "creates a new Net::HTTP::Post object" do
      expect(Net::HTTP::Post).to receive(:new).with(request_uri).and_return(request_object)
      HTTP.post(uri, form_data)
    end
  end

  context "with headers supplied" do
    let(:uri){'http://example.com/path'}
    let(:parsed_uri){URI.parse(uri)}
    let(:headers) do; {'User-Agent' => 'Rspec'}; end
    let(:request_uri){parsed_uri.request_uri}
    let(:request_object){Net::HTTP::Post.new(request_uri)}

    before do
      stub_request(:post, 'http://example.com/path').
        with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Rspec'}).
          to_return(status: 200, body: '', headers: {})
    end

    it "sets the headers on the request object" do
      allow(Net::HTTP::Post).to receive(:new).with(request_uri).and_return(request_object)
      HTTP.post(uri, {}, headers)
      expect(request_object['User-Agent']).to eq('Rspec')
    end
  end

  context "with options supplied" do
    let(:uri){'http://example.com/path'}
    let(:parsed_uri){URI.parse(uri)}
    let(:net_http_object){Net::HTTP.new(parsed_uri.host, parsed_uri.port)}
    let(:options) do; {use_ssl: true}; end

    before do
      stub_request(:post, 'https://example.com:80/path').
        with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(status: 200, body: '', headers: {})
    end

    it "sets the use_ssl option on the Net::HTTP instance" do
      allow(Net::HTTP).to receive(:new).with(parsed_uri.host, parsed_uri.port).and_return(net_http_object)
      HTTP.post(uri, {}, {}, options)
      expect(net_http_object.instance_variable_get(:@use_ssl)).to be_truthy
    end
  end

  context "with block supplied" do
    let(:uri){'http://example.com/path'}

    before do
      stub_request(:post, 'http://example.com/path').
        with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(status: 200, body: '', headers: {})
    end

    it "yields an instance of Net::HTTPResponse" do
      expect{|b| HTTP.post(uri, &b)}.to yield_with_args(Net::HTTPResponse)
      HTTP.post(uri){|response|}
    end
  end

  context "with redirection" do
    let(:request_uri){'http://example.com/path'}
    let(:redirect_uri){'http://redirected.com'}

    before do
      stub_request(:get, redirect_uri).
        with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(status: 200, body: '', headers: {})
    end

    context "via 301" do
      before do
        stub_request(:post, request_uri).
          with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
            to_return(status: '301', body: '', headers: {'location' => redirect_uri})
      end

      it "does a redirect" do
        expect(HTTP).to receive(:post).once.with(request_uri).and_call_original
        expect(HTTP).to receive(:get).once.with(redirect_uri, {}, {}, {}).and_call_original
        HTTP.post(request_uri)
      end
    end

    context "via 302" do
      before do
        stub_request(:post, request_uri).
          with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
            to_return(status: '302', body: '', headers: {'location' => redirect_uri})
      end

      it "does a redirect" do
        expect(HTTP).to receive(:post).with(request_uri).and_call_original
        expect(HTTP).to receive(:get).with(redirect_uri, {}, {}, {}).and_call_original
        HTTP.post(request_uri)
      end
    end
  end

end
