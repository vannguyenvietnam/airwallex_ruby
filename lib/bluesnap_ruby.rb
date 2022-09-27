require "bluesnap_ruby/version"
require "bluesnap_ruby/error"
require "bluesnap_ruby/base"
require "bluesnap_ruby/vendor"
require "bluesnap_ruby/vaulted_shopper"
require "bluesnap_ruby/transaction"
require "bluesnap_ruby/alt_transaction"
require "bluesnap_ruby/refund"
require "bluesnap_ruby/report"

module BluesnapRuby
  @@api_url    = 'https://sandbox.bluesnap.com'
  @@password = nil
  @@username = nil
  @@version = nil

  def self.api_url
    @@api_url
  end

  def self.api_url=(url)
    temp_url = url.to_s
    temp_url = 'https://' + temp_url unless temp_url.include?('https://')
    @@api_url = temp_url
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

  def self.version
    @@version
  end

  def self.version=(value)
    @@version = value
  end
end
