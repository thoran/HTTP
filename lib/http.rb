# 20090817
require 'mechanize_helper'

module HTTP
  
  def get(url, args = {}, agent = 'Windows IE 6', mech_instance = nil)
    uri = URI.parse(url)
    url = WWW::MechanizeHelper::Url.to_s(uri.scheme, uri.host, uri.port, uri.path, args)
    page = WWW::MechanizeHelper::Page.new(url, {}, agent, mech_instance)
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
        WWW::MechanizeHelper::Url.to_s(uri.scheme, uri.host, uri.port, uri.path)
      when WWW::MechanizeHelper::Page
        url_or_page_object.url
      end
    )
    page = WWW::MechanizeHelper::Page.new(url, args, agent, mech_instance)
    if block_given?
      yield page
    else
      page
    end
  end
  
end
