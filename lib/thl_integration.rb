require "thl_integration/engine"
require 'open-uri'
require 'thl_cookie'
require 'thl_integration/site'
require 'hpricot'

# The following are loaded automatically
#ActionView::Base.send :include, ThlIntegrationHelper
#ActionView::Base.send :include, FrameHelper
#ActionView::Base.send :include, TinyMceExtensionHelper

module ThlIntegration
  def self.get_layout_document(options = Hash.new)
#    case InterfaceUtils::Server.environment
#    when InterfaceUtils::Server::DEVELOPMENT
#      domain = 'dev.thlib.org'
#    when InterfaceUtils::Server::STAGING
      domain = 'staging.thlib.org'
#    when InterfaceUtils::Server::PRODUCTION
#      domain = 'www.thlib.org'
#    else
#      domain = 'www.thlib.org'
#    end
    if options[:template].blank?
      get_content("http://#{domain}/global/php/offsite.php?url=/template/index-offsite.php")
    else
      get_content("http://#{domain}/global/php/offsite.php?url=/template/#{options[:template]}.php")
    end
  end
  
  private
  
  def self.get_content(url)
    begin
      #site = open(url).read
      #site.gsub!('http:', 'https:')
      #site.gsub!('staging.', 'www.')
      #File.write('index-offsite.html', site)
      site = File.open('index-offsite.html')
      doc = Hpricot(site)
      #doc = Hpricot(open(url))
      yield doc if block_given?
      return doc
    rescue Errno::EHOSTUNREACH
      "Can't connect to #{url}"
    rescue Errno::ETIMEDOUT
      "Can't connect to #{url}"
    rescue SocketError
      "Can't connect to #{url}"      
    end
    return nil
  end
end