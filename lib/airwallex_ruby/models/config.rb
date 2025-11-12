module AirwallexRuby
  module Model
    class Config < Base
      attr_accessor :data

      ENDPOINT = '/pa/config'

      # Fetches current reserve plan using the API.
      #
      # @return [AirwallexRuby::Config]
      def self.reserve_plan options = {}
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/reserve_plan" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(data: response_body)
      end

      # Fetches available payment method types using the API.
      #
      # @param [Hash] options
      # @options [Boolean] :active - Indicate whether the payment method type is active
      # @options [String] :country_code - The supported country code of the shopper.
      # @options [String] :transaction_currency - The supported transaction currency. transaction_currency is required when country_code is given.
      # @options [String] :transaction_mode - The supported transaction mode. One of oneoff, recurring.
      # @options [Integer] :page_num - Page number starting from 0
      # @options [Integer] :page_size - Number of payment method types to be listed per page. Default value is 100. Maximum is 1000. The value greater than the maximum will be capped to the maximum.
      # @return [AirwallexRuby::AccountCapability]
      def self.payment_method_types options = {}
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri|
          uri.path += "#{ENDPOINT}/payment_method_types"
        end

        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(data: item.deep_symbolize_keys) }
      end

      # Fetches available bank names using the API.
      #
      # @param [Hash] options
      # @options [String] :payment_method_type - The payment method type to find the available banks. For other payment methods that don't require bank_name, an empty list will be returned.
      # @options [String] :country_code - For payment method type like online_banking and bank_transfer, the available bank list differs by different countries and country_code is needed to get the bank list.
      # @options [Integer] :page_num - Page number starting from 0
      # @options [Integer] :page_size - Number of payment method types to be listed per page. Default value is 100. Maximum is 1000. The value greater than the maximum will be capped to the maximum.
      # @return [AirwallexRuby::AccountCapability]
      def self.banks options = {}
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri|
          uri.path += "#{ENDPOINT}/banks"
        end

        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(data: item.deep_symbolize_keys) }
      end

      # Fetches current apple pay registered domains using the API.
      #
      # @return [AirwallexRuby::Config]
      def self.applepay_registered_domains options = {}
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/applepay/registered_domains" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(data: response_body)
      end

      # Fetches current convertible shopper currencies using the API.
      #
      # @return [AirwallexRuby::Config]
      def self.convertible_shopper_currencies options = {}
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/convertible_shopper_currencies" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(data: response_body)
      end

      # Add apple pay registered domains using the API.
      #
      # @return [AirwallexRuby::Config]
      def self.add_applepay_registered_domains domain_data, options = {}
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/applepay/registered_domains/add_items" 
        end

        response = post(request_url, domain_data, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(data: response_body)
      end

      # Remove apple pay registered domains using the API.
      #
      # @return [AirwallexRuby::Config]
      def self.remove_applepay_registered_domains domain_data, options = {}
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/applepay/registered_domains/remove_items" 
        end

        response = post(request_url, domain_data, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(data: response_body)
      end
      # End of class Config
    end
  end
end
