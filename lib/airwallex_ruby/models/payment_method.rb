module AirwallexRuby
  module Model
    class PaymentMethod < Base
      attr_accessor :id, :ach_direct_debit, :applepay, :bacs_direct_debit, :becs_direct_debit, :card, :created_at,
                    :customer_id, :eft_direct_debit, :googlepay, :metadata, :request_id, :sepa_direct_debit,
                    :status, :type, :updated_at

      ENDPOINT = '/pa/payment_methods'

      # Uses the API to create a payment method.
      #
      # @param [Hash] payment_method_data
      # @option payment_method_data [String] :customer_id *required*
      # @option payment_method_data [String] :request_id *required*
      # @option payment_method_data [String] :type *required*
      # @return [AirwallexRuby::PaymentMethod]
      def self.create(payment_method_data, options = {})
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, payment_method_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Update a payment method using the API.
      #
      # @param [String] payment_method_id *required*
      # @param [Hash] payment_method_data *required*
      # @return [AirwallexRuby::PaymentMethod]
      def self.update(payment_method_id, payment_method_data, options = {})
        temp_account = new(id: payment_method_id)
        temp_account.update(payment_method_data, options)
      end

      # Fetches all payment methods using the API.
      #
      # @param [Hash] options
      # @options [String] :customer_id - Customer ID of the PaymentMethods.
      # @options [String] :from_created_at - The start time of created_at in ISO8601 format.
      # @options [String] :status - PaymentMethod status. One of CREATED, DISABLED.
      # @options [String] :to_created_at - The end time of created_at in ISO8601 format.
      # @options [String] :type - PaymentMethod type, can be card, ach_direct_debit.
      # @options [Integer] :page_num - Page number starting from 0.
      # @options [Integer] :page_size - Number of PaymentMethods to be listed per page. Default value is 10. Maximum is 1000. The value greater than the maximum will be capped to the maximum.
      # @return [Array<AirwallexRuby::PaymentMethod>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a payment method using the API.
      #
      # @param [String] payment_method_id the Payment Method Id
      # @return [AirwallexRuby::PaymentMethod]
      def self.find(payment_method_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{payment_method_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Generate client secret for a customer for activation using the API.
      #
      # @param [String] customer_id the Customer Id
      # @return [AirwallexRuby::Customer]
      def self.generate_client_secret(customer_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{customer_id}/generate_client_secret" 
        end

        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Update a payment method using the API.
      #
      # @param [Hash] payment_method_data
      # @return [AirwallexRuby::PaymentMethod]
      def update(payment_method_data, options = {})
        attributes = self.class.attributes - [:id]
        request_body = self.class.parse_body_for_request(attributes, payment_method_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{id}/update" }
        response = self.class.post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        self.class.new(response_body)
      end
      # End of Customer class
    end
  end
end
