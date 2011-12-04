require 'active_support'
module ThlCookie
  def self.session_key
    'thl_session'
  end
  
  def self.session_secret
    secret_file = File.join(RAILS_ROOT, "secret.txt")
    if File.exist?(secret_file)
      secret = File.read(secret_file)
    else
      secret = ActiveSupport::SecureRandom.hex(64)
      File.open(secret_file, 'w') { |f| f.write(secret) }
    end
    secret
  end  
end