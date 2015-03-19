# HTTP#get

# 20120611
# 0.6.0

# Changes since 0.5: 
# 1. Swapped back to using MechanizeHelper again, but with encoding support.  

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
  
end
