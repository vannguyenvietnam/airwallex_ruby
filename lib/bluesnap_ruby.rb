require "bluesnap_ruby/version"

module BluesnapRuby
  @@api_url    = 'https://sandbox.bluesnap.com'
  @@password = nil
  @@username = nil

  def self.api_url
    @@api_url
  end

  def self.api_url=(url)
    url = 'https://' + url unless url.include?('https://')
    @@api_url = url
  end

  def self.password
    @@password
  end

  def self.password=(value)
    @@password = value
  end

  def self.username
    @@username
  end

  def self.username=(value)
    @@username = value
  end
end
