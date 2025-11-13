module AirwallexRuby
  module Model
    class FundsSplitReversal < Base
      attr_accessor :id, :amount, :created_at, :funds_split_id, :metadata, :request_id, :status

      ENDPOINT = '/pa/funds_split_reversals'

      # Uses the API to create a payment method.
      #
      # @param [Hash] funds_split_reversal_data
      # @option funds_split_reversal_data [String] :amount *required*
      # @option funds_split_reversal_data [String] :funds_split_id *required*
      # @option funds_split_reversal_data [String] :request_id *required*
      # @return [AirwallexRuby::FundsSplitReversal]
      def self.create(funds_split_reversal_data, options = {})
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, funds_split_reversal_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Fetches all funds split reversals using the API.
      #
      # @param [Hash] options
      # @options [String] :funds_split_id - ID of which funds_split this funds_split_reversal would be created from.
      # @options [Integer] :page_num - Page number starting from 0.
      # @options [Integer] :page_size - Number of Fund Split Reversals to be listed per page. Default value is 10. Maximum is 1000. The value greater than the maximum will be capped to the maximum.
      # @return [Array<AirwallexRuby::FundsSplitReversal>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a funds split reversal using the API.
      #
      # @param [String] funds_split_reversal_id the Funds Split Reversal Id
      # @return [AirwallexRuby::FundsSplitReversal]
      def self.find(funds_split_reversal_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{funds_split_reversal_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end
      # End of FundsSplitReversal class
    end
  end
end
