module ThlSite
  @@url = nil
  def self.get_url
    if @@url.nil?
      hostname = Socket.gethostname.downcase
      if hostname == 'sds6.itc.virginia.edu'
        @@url = 'http://staging.thlib.org'
      elsif hostname == 'dev.thlib.org'
        @@url = 'http://dev.thlib.org'
      elsif hostname =~ /sds[3-8].itc.virginia.edu/
        @@url = 'http://www.thlib.org'
      else
        @@url = 'http://www.thlib.org'
      end
    end
    @@url
  end
end