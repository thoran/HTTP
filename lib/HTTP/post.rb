# HTTP#post

# 20120403
# 0.4.0

# Changes since 0.3: 
# 1. Separated get and post.  
# 2. + module_function :post.  
# 3. Explicitly requiring 'uri', rather than relying on it being there implicitly by virtue of it being used in MechanizeHelper, if not Mechanize itself.  
# 4. Fixed a bug whereby the arguments were being passed on directly to MechanizeHelper::Page without being put into a :post hash.  

require 'MechanizeHelper.rbd/MechanizeHelper'
require 'uri'

module HTTP
  
  def post(url_or_page_object, args = {}, agent = 'Windows IE 6', mech_instance = nil)
    url = (
      case url_or_page_object
      when String
        uri = URI.parse(url_or_page_object)
        MechanizeHelper::Url.to_s(uri.scheme, uri.host, uri.port, uri.path)
      when MechanizeHelper::Page
        url_or_page_object.url
      end
    )
    page = MechanizeHelper::Page.new(url, {:post => args}, agent, mech_instance)
    if block_given?
      yield page
    else
      page
    end
  end
  
end
