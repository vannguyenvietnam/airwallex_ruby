module AirwallexRuby
  module Model
    class PaymentConsent < Base
      attr_accessor :id, :client_secret, :connected_account_id, :created_at, :customer_id, :disable_reason, 
                    :failure_reason, :initial_payment_intent_id, :mandate, :merchant_trigger_reason, :metadata,
                    :next_action, :next_triggered_by, :payment_method, :request_id, :status, :terms_of_use,
                    :updated_at

      ENDPOINT = '/pa/payment_consents'

      # Uses the API to create a payment consent.
      #
      # @param [Hash] payment_consent_data
      # @option payment_consent_data [String] :customer_id *required*
      # @option payment_consent_data [String] :next_triggered_by *required*
      # @option payment_consent_data [String] :request_id *required*
      # @return [AirwallexRuby::PaymentConsent]
      def self.create(payment_consent_data, options = {})
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, payment_consent_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Update a payment consent using the API.
      #
      # @param [String] payment_consent_id *required*
      # @param [Hash] payment_consent_data *required*
      # @return [AirwallexRuby::PaymentConsent]
      def self.update(payment_consent_id, payment_consent_data, options = {})
        temp_account = new(id: payment_consent_id)
        temp_account.update(payment_consent_data, options)
      end

      # Fetches all payment consents using the API.
      #
      # @param [Hash] options
      # @options [String] :customer_id - The unique identifier of a customer.
      # @options [String] :from_created_at - The start time of created_at in ISO8601 format.
      # @options [String] :merchant_trigger_reason - One of scheduled, unscheduled
      # @options [String] :next_triggered_by - One of merchant, customer.
      # @options [String] :payment_method_id - The unique identifier of a PaymentMethod
      # @options [String] :status - Status of PaymentConsent
      # @options [String] :to_created_at - The end time of created_at in ISO8601 format
      # @options [Integer] :page_num - Page number starting from 0.
      # @options [Integer] :page_size - Number of PaymentConsents to be listed per page. Default value is 10. Maximum is 1000. The value greater than the maximum will be capped to the maximum.
      # @return [Array<AirwallexRuby::PaymentConsent>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a payment consent using the API.
      #
      # @param [String] payment_consent_id the Payment Consent Id
      # @return [AirwallexRuby::PaymentConsent]
      def self.find(payment_consent_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{payment_consent_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Verify a payment consent using the API.
      #
      # @param [String] payment_consent_id the Payment Consent Id
      # @return [AirwallexRuby::PaymentConsent]
      def self.verify(payment_consent_id, payment_consent_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{payment_consent_id}/verify" 
        end

        response = post(request_url, payment_consent_data, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Continue verifying a payment consent using the API.
      #
      # @param [String] payment_consent_id the Payment Consent Id
      # @return [AirwallexRuby::PaymentConsent]
      def self.verify_continue(payment_consent_id, payment_consent_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{payment_consent_id}/verify_continue" 
        end

        response = post(request_url, payment_consent_data, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Disable a payment consent using the API.
      #
      # @param [String] payment_consent_id the Payment Consent Id
      # @return [AirwallexRuby::PaymentConsent]
      def self.disable(payment_consent_id, payment_consent_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{payment_consent_id}/disable" 
        end

        response = post(request_url, payment_consent_data, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Update a payment consent using the API.
      #
      # @param [Hash] payment_consent_data
      # @return [AirwallexRuby::PaymentConsent]
      def update(payment_consent_data, options = {})
        attributes = self.class.attributes - [:id]
        request_body = self.class.parse_body_for_request(attributes, payment_consent_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{id}/update" }
        response = self.class.post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        self.class.new(response_body)
      end
      # End of Customer class
    end
  end
end
