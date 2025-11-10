module AirwallexRuby
  @@environment          = :sandbox
  @@client_id            = nil
  @@api_key              = nil
  @@access_token         = nil
  @@api_version          = 'v1'

  def self.environment
    @@environment
  end

  def self.environment=(value)
    @@environment = value
  end

  def self.client_id
    @@client_id
  end

  def self.client_id=(value)
    @@client_id = value
  end

  def self.api_key
    @@api_key
  end

  def self.api_key=(value)
    @@api_key = value
  end

  def self.access_token
    @@access_token
  end

  def self.access_token=(value)
    @@access_token = value
  end

  def self.api_version
    @@api_version
  end

  def self.api_version=(value)
    @@api_version = value
  end

  def self.api_server_url
    AirwallexRuby::SERVER[environment][:api_url]
  end

  def self.file_server_url
    AirwallexRuby::SERVER[environment][:file_url]
  end

  def self.api_url
    "#{api_server_url}/#{api_version}"
  end

  def self.simulation_api_url
    "#{api_server_url}/#{api_version}/simulation"
  end

  def self.file_url
    "#{file_server_url}/#{api_version}"
  end
end
