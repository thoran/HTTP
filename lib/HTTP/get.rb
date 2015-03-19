# HTTP/get
# HTTP#get

# 20121002
# 0.7.0

# Changes since 0.6: 
# 1. + module_function :post.  

require 'MechanizeHelper.rbd/MechanizeHelper'
require 'uri'

module HTTP
  
  def get(url, args = {}, agent = 'Windows IE 6', mech_instance = nil, encoding = 'UTF-8')
    uri = URI.parse(url)
    url = MechanizeHelper::Url.to_s(uri.scheme, uri.host, uri.port, uri.path, args)
    page = MechanizeHelper::Page.new(url, {}, agent, mech_instance, encoding)
    if block_given?
      yield page
    else
      page
    end
  end
  
  module_function :get
  
end
