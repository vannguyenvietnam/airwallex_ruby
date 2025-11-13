module AirwallexRuby
  module Model
    class Refund < Base
      attr_accessor :id, :acquirer_reference_number, :amount, :created_at, :currency, :failure_details, :metadata,
                    :payment_attempt_id, :payment_intent_id, :reason, :request_id, :status, :updated_at

      ENDPOINT = '/pa/refunds'

      # Uses the API to create a refund.
      #
      # @param [Hash] refund_data
      # @option refund_data [String] :request_id *required*
      # @return [AirwallexRuby::Refund]
      def self.create(refund_data, options = {})
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, refund_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Fetches all refunds using the API.
      #
      # @param [Hash] options
      # @options [String] :currency - Refund currency.
      # @options [String] :from_created_at - The start time of created_at in ISO8601 format.
      # @options [String] :payment_attempt_id - PaymentAttempt ID of the Refunds.
      # @options [String] :payment_intent_id - PaymentIntent ID of the Refunds.
      # @options [String] :status - Refund status.
      # @options [String] :to_created_at - The end time of created_at in ISO8601 format.
      # @options [Integer] :page_num - Page number starting from 0.
      # @options [Integer] :page_size - Number of Refunds to be listed per page. Default value is 10. Maximum is 1000. The value greater than the maximum will be capped to the maximum.
      # @return [Array<AirwallexRuby::Refund>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a refund using the API.
      #
      # @param [String] refund_id the Refund Id
      # @return [AirwallexRuby::Refund]
      def self.find(refund_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{refund_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end
      # End of Refund class
    end
  end
end
