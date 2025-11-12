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
    end
  end
end
