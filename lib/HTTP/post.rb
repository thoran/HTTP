# HTTP#post

# 20120611
# 0.6.0

# Changes since 0.5: 
# 1. Swapped back to using MechanizeHelper again, but with encoding support.  

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
  
end
