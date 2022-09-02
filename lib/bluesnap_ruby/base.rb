require 'json'
require 'bluesnap_ruby/error'
require 'net/http'

module BluesnapRuby
  class Base

    def initialize options = {}
      self.class.parse_data(options).each do |k, v| 
        send("#{k}=", v) if self.class.attributes.include?(k.to_sym) 
      end
    end

    protected

    def self.attr_accessor(*vars)
      @attributes ||= []
      @attributes.concat vars
      super(*vars)
    end
  
    def self.attributes
      @attributes
    end
  
    def attributes
      self.class.attributes
    end

    def self.post uri, options = {}
      fetch Net::HTTP::Post, uri, options
    end

    def self.put uri, options = {}
      fetch Net::HTTP::Put, uri, options
    end

    def self.get uri, options = {}
      fetch Net::HTTP::Get, uri, options
    end
    
    def self.delete uri, options = {}
      fetch Net::HTTP::Delete, uri, options
    end

    def self.fetch klass, uri, options
      client             = Net::HTTP.new(uri.host, uri.port)
      client.use_ssl     = true
      client.verify_mode = OpenSSL::SSL::VERIFY_PEER

      response           = client.request(
        klass.new(uri.request_uri).tap do |http|
          base_key = Base64.strict_encode64("#{BluesnapRuby.username}:#{BluesnapRuby.password}")
          http["Authorization"] = "Basic #{base_key}"
          http["Content-Type"] = "application/json"
          http["Accept"] = "application/json"
          http.body = JSON.dump(options)
        end
      )

      begin
        response = JSON.parse(response.body)
      rescue JSON::ParserError => e
        raise Error::InvalidResponse.new(e.message)
      end

      if response['error']
        raise(Error.create(response['error'], response['error_description'], response['messages'])) 
      end

      response = response['response']
      response.is_a?(Hash) ? parse_object_tokens(response) : response.map{|x| parse_object_tokens(x) }
    end

    def self.deep_snake_case_keys(hash)
      temp_hash = hash.dup
      return temp_hash unless temp_hash.is_a?(Hash)
      return temp_hash if temp_hash.blank?

      temp_hash.deep_transform_keys { |key| key.to_s.underscore.to_sym }
    end

    def self.deep_camelize_keys(hash)
      temp_hash = hash.dup
      return temp_hash unless temp_hash.is_a?(Hash)
      return temp_hash if temp_hash.blank?

      temp_hash.deep_transform_keys { |key| key.to_s.camelize.to_sym }
    end

    def self.parse_data hash
      deep_snake_case_keys(hash)
    end

    def self.parse_options_for_request attributes, options
      attributes = attributes.map(&:to_s)
      temp_options = options.select { |k, _| attributes.include?(k.to_s) }
      deep_camelize_keys(temp_options)
    end

  end
end
