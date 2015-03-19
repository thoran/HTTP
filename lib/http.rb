module HTTP
  
  def get(url, args = {}, agent = 'Windows IE 6', mech_instance = nil)
    uri = URI.parse(url)
    page = WWW::MechanizeHelper::Page.new(WWW::MechanizeHelper::Url.to_s(uri.scheme, uri.host, uri.port, uri.path, args), {}, agent, mech_instance)
    if block_given?
      yield page
    else
      page
    end
  end
  
  def post(url_or_page_object, args = {}, agent = 'Windows IE 6', mech_instance = nil)
    page = (
      case url_or_page_object
      when String
        uri = URI.parse(url_or_page_object)
        WWW::MechanizeHelper::Page.new(WWW::MechanizeHelper::Url.to_s(uri.scheme, uri.host, uri.port, uri.path), args, agent, mech_instance)
      when WWW::MechanizeHelper::Page
        WWW::MechanizeHelper::Page.new(path_or_page_object.url, args, agent, mech_instance)
      end
    )
    if block_given?
      yield page
    else
      page
    end
  end
  
end
