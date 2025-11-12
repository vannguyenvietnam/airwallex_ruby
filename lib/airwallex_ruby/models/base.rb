require 'json'
require 'airwallex_ruby/error'
require 'net/http'

module AirwallexRuby
  module Model
    class Base
      def assign_attributes(options = {})
        self.class.parse_data(options).each do |k, v| 
          send("#{k}=", v) if self.class.attributes.include?(k.to_sym) 
        end
      end

      def initialize(options = {})
        assign_attributes(options)
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

      def self.post(uri, request_body = {}, options = {})
        fetch(Net::HTTP::Post, uri, request_body, options)
      end

      def self.put(uri, request_body = {}, options = {})
        fetch(Net::HTTP::Put, uri, request_body, options)
      end

      def self.get(uri, request_body = {}, options = {})
        fetch(Net::HTTP::Get, uri, request_body, options)
      end
      
      def self.delete(uri, request_body = {}, options = {})
        fetch(Net::HTTP::Delete, uri, request_body, options)
      end

      def self.init_http_header(http, options = {})
        http["Content-Type"] = "application/json"
        http["Accept"] = "application/json"

        if options[:file]
          http["Content-Type"] = "multipart/form-data"
        end

        if options[:use_client_id]
          http["x-client-id"] = AirwallexRuby.client_id
          http["x-api-key"] = AirwallexRuby.api_key
        else
          http["Authorization"] = "Bearer #{AirwallexRuby.access_token}"
        end
        
        http["x-on-behalf-of"] = options[:on_behalf_of] if options[:on_behalf_of]
        # Return
        http
      end

      def self.fetch(klass, uri, request_body = {}, options = {})
        client             = Net::HTTP.new(uri.host, uri.port)
        client.use_ssl     = true
        client.verify_mode = OpenSSL::SSL::VERIFY_PEER
        puts uri.to_s

        response           = client.request(
          klass.new(uri).tap do |http|
            http = init_http_header(http, options)
            http.body = JSON.dump(request_body) if request_body.present?
          end
        )
        
        puts response.body
        return response if response.body.blank? || options[:no_response_body]

        begin
          response_body = JSON.parse(response.body)
        rescue JSON::ParserError => e
          raise Error::InvalidResponse.new(e.message)
        end

        raise Error.new(response_body) unless response_body.is_a?(Hash) || response_body.is_a?(Array)

        if response_body.is_a?(Hash) && response_body['message'].is_a?(Array)
          message = response_body['message'].first
          description = message.to_s
          description = message['description'] if message.is_a?(Hash)
          raise(Error.create(description, response_body))
        end

        if response_body.is_a?(Hash) && response_body['message']
          message = response_body['message'].to_s
          raise(Error.create(message, response_body))
        end

        response
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

        temp_hash.deep_transform_keys do |key| 
          temp = key.to_s.camelize.to_s
          temp[0] = temp[0].downcase
          temp.to_sym 
        end
      end

      def self.parse_data(hash)
        deep_snake_case_keys(hash)
      end

      def self.init_params_for_request(params = {})
        valid_params = params.deep_dup
        valid_params.delete(:on_behalf_of)
        valid_params.map { |k, v| "#{k}=#{ERB::Util.url_encode(v.to_s)}" }.join("\&")
      end

      def self.parse_body_for_request(attributes, request_body_hash)
        attributes = attributes.map(&:to_s)
        request_body_hash.select { |k, _| attributes.include?(k.to_s) }
      end
      # End of class Base
    end
  end
end
