require "airwallex_ruby/version"
require "airwallex_ruby/error"
require "airwallex_ruby/base"
require "airwallex_ruby/vendor"
require "airwallex_ruby/vaulted_shopper"
require "airwallex_ruby/transaction"
require "airwallex_ruby/alt_transaction"
require "airwallex_ruby/refund"
require "airwallex_ruby/report"

module AirwallexRuby
  @@api_url    = 'https://sandbox.airwallex.com'
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
