module HTTP
  
  def get(path_or_url, args = {}, mech_instance = nil)
    uri = URI.parse(path_or_url)
    if uri.scheme
      WWW::MechanizeHelper::Page.new(WWW::MechanizeHelper::Url.to_s(uri.scheme, uri.host, uri.port, uri.path, args))
    else
      WWW::MechanizeHelper::Page.new(WWW::MechanizeHelper::Url.to_s('http', DOMAIN, nil, path_or_url, args))
    end
  end
  
  def post(path_or_page_object, args = {}, mech_instance = nil)
    case path_or_page_object
    when String
      url = WWW::MechanizeHelper::Url.to_s('http', DOMAIN, path_or_path_object)
    when WWW::MechanizeHelper::Page
      url = path_or_page_object.url
    end
    pp url
    WWW::MechanizeHelper::Page.new(url, args, 'Windows IE 6', mech_instance)
  end
  
end
