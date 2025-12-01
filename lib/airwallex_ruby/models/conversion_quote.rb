module AirwallexRuby
  module Model
    class ConversionQuote < Base
      attr_accessor :id, :conversion_rate, :created_at, :expires_at, :merchant_currency, :shopper_currency, 
                    :status

      ENDPOINT = '/pa/conversion_quotes'

      # Uses the API to create a conversion quote.
      #
      # @param [Hash] conversion_quote_data
      # @option conversion_quote_data [String] :merchant_currency *required*
      # @option conversion_quote_data [String] :shopper_currency *required*
      # @option conversion_quote_data [String] :request_id *required*
      # @return [AirwallexRuby::ConversionQuote]
      def self.create(conversion_quote_data, options = {})
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, conversion_quote_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Fetches a conversion quote using the API.
      #
      # @param [String] conversion_quote_id the Conversion Quote Id
      # @return [AirwallexRuby::ConversionQuote]
      def self.find(conversion_quote_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{conversion_quote_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end
      # End of ConversionQuote class
    end
  end
end
