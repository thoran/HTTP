# HTTP#get

# 20120403
# 0.4.0

# Changes since 0.3: 
# 1. Separated get and post.  
# 2. + module_function :get.  
# 3. Explicitly requiring 'uri', rather than relying on it being there implicitly by virtue of it being used in MechanizeHelper, if not Mechanize itself.  

require 'MechanizeHelper.rbd/MechanizeHelper'
require 'uri'

module HTTP
  
  def get(url, args = {}, agent = 'Windows IE 6', mech_instance = nil)
    uri = URI.parse(url)
    url = MechanizeHelper::Url.to_s(uri.scheme, uri.host, uri.port, uri.path, args)
    page = MechanizeHelper::Page.new(url, {}, agent, mech_instance)
    if block_given?
      yield page
    else
      page
    end
  end
  
end
