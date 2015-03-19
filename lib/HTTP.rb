# HTTP

# 2010.05.27
# 0.3.0 or 0.4.0

# Changes since 0.2: 
# 1. - WWW namespace because the deprecation warnings from Mechanize were annoying me.  

require 'MechanizeHelper.rbd/MechanizeHelper'

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
    page = MechanizeHelper::Page.new(url, args, agent, mech_instance)
    if block_given?
      yield page
    else
      page
    end
  end
  
end
