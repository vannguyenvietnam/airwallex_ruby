module AirwallexRuby
  module Model
    class PaymentDispute < Base
      attr_accessor :id, :accept_details, :acquirer_reference_number, :amount, :card_brand, :challenge_details,
                    :created_at, :currency, :customer_id, :customer_name, :due_at, :issuer_comment,
                    :issuer_documents, :merchant_order_id, :mode, :payment_attempt_id, :payment_intent_id, 
                    :payment_method_type, :reason, :refunds, :stage, :status, :transaction_type, :updated_at

      ENDPOINT = '/pa/payment_disputes'

      # Fetches all payment disputes using the API.
      #
      # @param [Hash] options
      # @options [String] :customer_id - The customer ID of original payment.
      # @options [String] :customer_name - The customer name of original payment.
      # @options [String] :from_due_at - The start time of due_at in ISO8601 format.
      # @options [String] :from_updated_at - The start time of updated_at in ISO8601 format.
      # @options [String] :merchant_order_id - The order ID of original payment.
      # @options [String] :payment_intent_id - The payment intent ID of original payment.
      # @options [String] :payment_method_type - The payment method type of original payment.
      # @options [String] :reason_code - PaymentDispute reason code.
      # @options [String] :stage - PaymentDispute stage.
      # @options [String] :status - PaymentDispute status.
      # @options [String] :to_due_at - The end time of due_at in ISO8601 format.
      # @options [String] :to_updated_at - The end time of updated_at in ISO8601 format.
      # @options [String] :transaction_type - The transaction type of the original transaction. Possible values: PAYMENT, REFUND.
      # @options [String] :page - 0 or the BASE 64 encoded resource ID of PaymentDispute and navigation direction to indicate the page should be returned. 0 is used by default for initial page.
      # @options [Integer] :size - Number of PaymentDisputes to be listed per page. Default value is 10. Maximum is 1000. The value greater than the maximum will be capped to the maximum.
      # @return [Array<AirwallexRuby::PaymentDispute>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a payment dispute using the API.
      #
      # @param [String] payment_dispute_id the Payment Dispute Id
      # @return [AirwallexRuby::PaymentDispute]
      def self.find(payment_dispute_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{payment_dispute_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Accept a payment dispute using the API.
      #
      # @param [String] payment_dispute_id the Payment Dispute Id
      # @return [JSON::Hash]
      def self.accept(payment_dispute_id, accept_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{payment_dispute_id}/accept" 
        end

        response = post(request_url, accept_data, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Challenge a payment dispute using the API.
      #
      # @param [String] payment_dispute_id the Payment Dispute Id
      # @return [JSON::Hash]
      def self.challenge(payment_dispute_id, challenge_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{payment_dispute_id}/challenge" 
        end

        response = post(request_url, challenge_data, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Fetch related payment intents for a payment dispute using the API.
      #
      # @param [String] payment_dispute_id the Payment Dispute Id
      # @options [String] :page - A bookmark for use in pagination to retrieve either the next page or the previous page of results. You can fetch the value for this identifier from the response of the previous API call. To retrieve the next page of results, pass the value of page_after (if not null) from the response to a subsequent call. To retrieve the previous page of results, pass the value of page_before (if not null) from the response to a subsequent call.
      # @options [Integer] :page_size - Number of related payment intents to be listed per page. Maximum is 100.
      # @return [Array<JSON::Hash>]
      def self.related_payment_intents(payment_dispute_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{payment_dispute_id}/related_payment_intents" 
        end

        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| item.deep_symbolize_keys }
      end
      # End of PaymentDispute class
    end
  end
end
