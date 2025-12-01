module AirwallexRuby
  module Model
    class PaymentAttempt < Base
      attr_accessor :id, :acquirer_reference_number, :amount, :authentication_data, :authorization_code, 
                    :captured_amount, :created_at, :currency, :dcc_data, :failure_code, :failure_details,
                    :merchant_advice_code, :merchant_order_id, :payment_consent_id, :payment_intent_id, 
                    :payment_method, :payment_method_options, :payment_method_transaction_id, 
                    :provider_original_response_code, :provider_transaction_id, :refunded_amount,
                    :settle_via, :status, :updated_at

      ENDPOINT = '/pa/payment_attempts'

      # Fetches all payment attempts using the API.
      #
      # @param [Hash] options
      # @options [String] :currency - PaymentAttempt currency
      # @options [String] :from_created_at - The start time of created_at in ISO8601 format
      # @options [String] :payment_intent_id - PaymentIntent ID of the attempt
      # @options [String] :status - PaymentAttempt status
      # @options [String] :to_created_at - The end time of created_at in ISO8601 format
      # @options [Integer] :page_num - Page number starting from 0.
      # @options [Integer] :page_size - Number of PaymentAttempts to be listed per page. Default value is 10. Maximum is 1000. The value greater than the maximum will be capped to the maximum.
      # @return [Array<AirwallexRuby::PaymentAttempt>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a payment attempt using the API.
      #
      # @param [String] payment_attempt_id the Payment Attempt Id
      # @return [AirwallexRuby::PaymentAttempt]
      def self.find(payment_attempt_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{payment_attempt_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end
      # End of PaymentAttempt class
    end
  end
end
