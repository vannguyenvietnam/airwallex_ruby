module AirwallexRuby
  module Model
    class PaymentIntent < Base
      attr_accessor :id, :additional_info, :amount, :cancellation_reason, :cancelled_at, :captured_amount, 
                    :client_secret, :connected_account_id, :conversion_quote_id, :created_at, :currency,
                    :customer, :customer_id, :descriptor, :funds_split_data, :invoice_id, :latest_payment_attempt,
                    :merchant_order_id, :metadata, :next_action, :order, :payment_consent, :payment_consent_id,
                    :payment_link_id, :payment_method_options, :request_id, :return_url, :risk_control_options,
                    :status, :triggered_by, :updated_at

      ENDPOINT = '/pa/payment_intents'

      # Uses the API to create a payment intent.
      #
      # @param [Hash] payment_intent_data
      # @option payment_intent_data [String] :amount *required*
      # @option payment_intent_data [String] :currency *required*
      # @option payment_intent_data [String] :merchant_order_id *required*
      # @option payment_intent_data [String] :request_id *required*
      # @return [AirwallexRuby::PaymentIntent]
      def self.create(payment_intent_data, options = {})
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, payment_intent_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Update a payment intent using the API.
      #
      # @param [String] payment_intent_id *required*
      # @param [Hash] payment_intent_data *required*
      # @return [AirwallexRuby::PaymentIntent]
      def self.update(payment_intent_id, payment_intent_data, options = {})
        temp_account = new(id: payment_intent_id)
        temp_account.update(payment_intent_data, options)
      end

      # Fetches all payment intents using the API.
      #
      # @param [Hash] options
      # @options [String] :currency - PaymentIntent currency.
      # @options [String] :from_created_at - The start time of created_at in ISO8601 format.
      # @options [String] :merchant_order_id - Merchant Order ID
      # @options [String] :payment_consent_id - Payment Consent ID.
      # @options [String] :status - PaymentIntent status.
      # @options [String] :to_created_at - The end time of created_at in ISO8601 format
      # @options [Integer] :page_num - Page number starting from 0.
      # @options [Integer] :page_size - Number of PaymentIntents to be listed per page. Default value is 10. Maximum is 1000. The value greater than the maximum will be capped to the maximum.
      # @return [Array<AirwallexRuby::PaymentIntent>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a payment intent using the API.
      #
      # @param [String] payment_intent_id the Payment Intent Id
      # @return [AirwallexRuby::PaymentIntent]
      def self.find(payment_intent_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{payment_intent_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Confirm a payment intent using the API.
      #
      # @param [String] payment_intent_id the Payment Intent Id
      # @return [AirwallexRuby::PaymentIntent]
      def self.confirm(payment_intent_id, payment_intent_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{payment_intent_id}/confirm" 
        end

        response = post(request_url, payment_intent_data, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Continue confirming a payment intent using the API.
      #
      # @param [String] payment_intent_id the Payment Intent Id
      # @return [AirwallexRuby::PaymentIntent]
      def self.confirm_continue(payment_intent_id, payment_intent_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{payment_intent_id}/confirm_continue" 
        end

        response = post(request_url, payment_intent_data, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Increment authorization for a payment intent using the API.
      #
      # @param [String] payment_intent_id the Payment Intent Id
      # @return [AirwallexRuby::PaymentIntent]
      def self.increment_authorization(payment_intent_id, payment_intent_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{payment_intent_id}/increment_authorization" 
        end

        response = post(request_url, payment_intent_data, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Capture a payment intent using the API.
      #
      # @param [String] payment_intent_id the Payment Intent Id
      # @return [AirwallexRuby::PaymentIntent]
      def self.capture(payment_intent_id, payment_intent_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{payment_intent_id}/capture" 
        end

        response = post(request_url, payment_intent_data, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Cancel a payment intent using the API.
      #
      # @param [String] payment_intent_id the Payment Intent Id
      # @return [AirwallexRuby::PaymentIntent]
      def self.cancel(payment_intent_id, payment_intent_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{payment_intent_id}/cancel" 
        end

        response = post(request_url, payment_intent_data, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Update a payment intent using the API.
      #
      # @param [Hash] payment_intent_data
      # @return [AirwallexRuby::PaymentIntent]
      def update(payment_intent_data, options = {})
        attributes = self.class.attributes - [:id]
        request_body = self.class.parse_body_for_request(attributes, payment_intent_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{id}/update" }
        response = self.class.post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        self.class.new(response_body)
      end
      # End of Customer class
    end
  end
end
