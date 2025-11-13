module AirwallexRuby
  module Model
    class Customer < Base
      attr_accessor :id, :address, :business_name, :client_secret, :created_at, :email, :first_name,
                    :last_name, :merchant_customer_id, :metadata, :phone_number, :request_id, :updated_at

      ENDPOINT = '/pa/customers'

      # Uses the API to create a customer.
      #
      # @param [Hash] customer_data
      # @option customer_data [String] :merchant_customer_id *required*
      # @option customer_data [String] :request_id *required*
      # @return [AirwallexRuby::Customer]
      def self.create(customer_data, options = {})
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, customer_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Update a customer using the API.
      #
      # @param [String] customer_id *required*
      # @param [Hash] customer_data *required*
      # @return [AirwallexRuby::Customer]
      def self.update(customer_id, customer_data, options = {})
        temp_account = new(id: customer_id)
        temp_account.update(customer_data, options)
      end

      # Fetches all customers using the API.
      #
      # @param [Hash] options
      # @options [String] :from_created_at - The start time of created_at in ISO8601 format.
      # @options [String] :merchant_customer_id - The customer ID on merchant side.
      # @options [String] :to_created_at - The end time of created_at in ISO8601 format
      # @options [Integer] :page_num - Page number starting from 0.
      # @options [Integer] :page_size - Number of Customers to be listed per page. Default value is 10. Maximum is 1000. The value greater than the maximum will be capped to the maximum.
      # @return [Array<AirwallexRuby::Customer>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a customer using the API.
      #
      # @param [String] customer_id the Customer Id
      # @return [AirwallexRuby::Customer]
      def self.find(customer_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{customer_id}" }
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

      # Update a Customer using the API.
      #
      # @param [Hash] customer_data
      # @return [AirwallexRuby::Customer]
      def update(customer_data, options = {})
        attributes = self.class.attributes - [:id]
        request_body = self.class.parse_body_for_request(attributes, account_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{id}/update" }
        response = self.class.post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        self.class.new(response_body)
      end
      # End of Customer class
    end
  end
end
