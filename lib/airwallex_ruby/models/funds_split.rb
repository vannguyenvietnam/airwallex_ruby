module AirwallexRuby
  module Model
    class FundsSplit < Base
      attr_accessor :id, :amount, :auto_release, :created_at, :currency, :destination, :metadata, :request_id,
                    :source_id, :source_type, :status

      ENDPOINT = '/pa/funds_splits'

      # Uses the API to create a funds split.
      #
      # @param [Hash] funds_split_data
      # @option funds_split_data [String] :amount *required*
      # @option funds_split_data [String] :destination *required*
      # @option funds_split_data [String] :request_id *required*
      # @option funds_split_data [String] :source_id *required*
      # @option funds_split_data [String] :source_type *required*
      # @return [AirwallexRuby::FundsSplit]
      def self.create(funds_split_data, options = {})
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, funds_split_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Fetches all funds splits using the API.
      #
      # @param [Hash] options
      # @options [String] :source_id - ID of which source this split would be created from. Currently only payment_intent_id is supported.
      # @options [String] :source_type - Type of the source for this split. Currently only PAYMENT_INTENT is supported.
      # @options [Integer] :page_num - Page number starting from 0.
      # @options [Integer] :page_size - Number of Fund Splits to be listed per page. Default value is 10. Maximum is 1000. The value greater than the maximum will be capped to the maximum.
      # @return [Array<AirwallexRuby::FundsSplit>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a funds split using the API.
      #
      # @param [String] funds_split_id the Funds Split Id
      # @return [AirwallexRuby::FundsSplit]
      def self.find(funds_split_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{funds_split_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Release a funds split for a customer using the API.
      #
      # @param [String] funds_split_id the Funds Split Id
      # @return [AirwallexRuby::FundsSplit]
      def self.release(funds_split_id, funds_split_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{funds_split_id}/release" 
        end

        response = post(request_url, funds_split_data, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end
      # End of FundsSplit class
    end
  end
end
