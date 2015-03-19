# HTTP/post
# HTTP#post

# 20121002
# 0.7.0

# Changes since 0.6: 
# 1. + module_function :post.  

require 'MechanizeHelper.rbd/MechanizeHelper'
require 'uri'

module HTTP
  
  def post(url_or_page_object, args = {}, agent = 'Windows IE 6', mech_instance = nil, encoding = 'UTF-8')
    url = (
      case url_or_page_object
      when String
        uri = URI.parse(url_or_page_object)
        MechanizeHelper::Url.to_s(uri.scheme, uri.host, uri.port, uri.path)
      when MechanizeHelper::Page
        url_or_page_object.url
      end
    )
    page = MechanizeHelper::Page.new(url, {:post => args}, agent, mech_instance, encoding)
    if block_given?
      yield page
    else
      page
    end
  end
  
  module_function :post

end
