require 'securerandom'
module ThlCookie
  def self.session_key
    '_thl_session'
  end
  
  def self.session_secret
    secret_file = Rails.root.join('secret.txt')
    if File.exist?(secret_file)
      secret = File.read(secret_file)
    else
      secret = SecureRandom.hex(64)
      File.open(secret_file, 'w') { |f| f.write(secret) }
    end
    secret
  end  
end