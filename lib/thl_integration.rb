require "thl_integration/engine"
require 'open-uri'
require 'thl_cookie'
require 'thl_site'

# The following are loaded automatically
#ActionView::Base.send :include, ThlIntegrationHelper
#ActionView::Base.send :include, FrameHelper
#ActionView::Base.send :include, TinyMceExtensionHelper

module ThlIntegration
  def self.get_layout_document(options = Hash.new)
    hostname = Socket.gethostname.downcase
    if hostname == 'sds6.itc.virginia.edu'
      headers = {}
      domain = 'staging.thlib.org'
    elsif hostname =~ /sds.+\.itc\.virginia\.edu/
      headers = { 'Host' => 'www.thlib.org' }
      domain = '127.0.0.1'
    elsif hostname == 'dev.thlib.org'
      headers = {}
      domain = 'dev.thlib.org'
    else
      headers = {}
      domain = 'www.thlib.org'
    end
    if options[:template].blank?
      get_content("http://#{domain}/global/php/offsite.php?url=/template/index-offsite.php", headers)
    else
      get_content("http://#{domain}/global/php/offsite.php?url=/template/#{options[:template]}.php", headers)
    end
  end
  
  private
  
  def self.get_content(url, headers={})
    begin
      doc = Hpricot(open(url, headers))
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