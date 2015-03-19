# HTTP/post.rb
# HTTP.post

# 20150303
# 0.9.11

# Changes since 0.8:
# 1. Can handle blocks as was the case up to 0.7.0, or pre 0.8.5 anyway.
# 0/1
# 2. ~ #post so as it can handle options for the http object.
# 1/2
# 3. Version number bump to match the change to HTTP.get.
# 2/3
# 4. + require 'openssl', since it seems to explicitly need to be required as of Ruby 2 somewhere.
# 3/4
# 5. Enabled Basic authentication to be automatically applied if there is a username and password in the supplied uri.
# 4/5
# 6. ~ #post so as it can handle 301's, though it isn't smart enough to detect infinite redirects.
# 5/6
# 7. /URI::HTTP/URI::Generic/, since the former wasn't working.
# 6/7
# 8. Also now handles redirects for 302's (temorary redirects) as well as 301's (permanent redirects).
# 7/8
# 9. I wasn't reconstructing the parameters before recursing and if I did that then I may as well pass in the location directly.  Not sure if there is much value in having the same arguments supplied to the initial request passed to any subsequent request, though I am passing in the options for now, though not the args/params nor the headers.
# 10. I also wasn't resassigning the response variable as I should with any of the returned values from subsequent calls else as it unwinds it will retain the value from the earlier recursion.
# 8/9
# 11. + require 'Net/HTTP/Post/set_headers' and removal of the same code from being here.
# 12. + require 'URI/Generic/use_sslQ' and removal of the same code from being here.
# 9/10
# 13. No longer parsing the response.header['location'], since it probably shouldn't be.
# 10/11
# 14. Accepts either a String or a URI in the argument list.

require 'net/http'
require 'openssl'
require 'uri'
require 'Net/HTTP/Post/set_headers'
require 'URI/Generic/use_sslQ'

module HTTP

  def post(uri, form_data = {}, headers = {}, options = {})
    uri = uri.is_a?(URI) ? uri : URI.parse(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = options[:use_ssl] || uri.use_ssl?
    http.verify_mode = options[:verify_mode] || OpenSSL::SSL::VERIFY_NONE
    options.each{|k,v| http.send("#{k}=", v)}
    request_object = Net::HTTP::Post.new(uri.request_uri)
    request_object.form_data = form_data
    request_object.headers = headers
    request_object.basic_auth(uri.user, uri.password) if uri.user
    response = http.request(request_object)
    if ['301', '302'].include?(response.code)
      response = get(response.header['location'], {}, {}, options, &block)
    end
    if block_given?
      yield response
    else
      response
    end
  end

  module_function :post

end

if __FILE__ == $0
  url = "http://w3schools.com/asp/demo_simpleform.asp"
  args = {fname: 'thoran'}
  puts HTTP.post(url, args)
end
