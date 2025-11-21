module AirwallexRuby
  module Model
    class Deposit < Base
      attr_accessor :id, :amount, :created_at, :currency, :estimated_settled_at, :failure_details, :fee,
                    :funding_source_id, :global_account_id, :payer, :provider_transaction_id, :reference, 
                    :settled_at, :status, :type, :deposit_type, :request_id

      ENDPOINT = '/deposits'

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

      # Fetches all deposits using the API.
      #
      # @param [Hash] options
      # @options [String] :from_created_at - The start date of created_at in ISO8601 format (inclusive)
      # @options [String] :to_created_at - The end date of created_at in ISO8601 format (inclusive)
      # @options [Integer] :page_num - Page number, starts from 0.
      # @options [Integer] :page_size - Number of results per page. Default value is 100.
      # @return [Array<AirwallexRuby::Deposit>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a deposit using the API.
      #
      # @param [String] deposit_id the Deposit Id
      # @return [AirwallexRuby::Deposit]
      def self.find(deposit_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{deposit_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end
      # End of Deposit class
    end
  end
end
