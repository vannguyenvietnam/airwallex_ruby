module AirwallexRuby
  module Model
    class FinancialTransaction < Base
      attr_accessor :id, :amount, :batch_id, :client_rate, :created_at, :currency, :currency_pair,
                    :description, :estimated_settled_at, :fee, :funding_source_id, :net, :settled_at,
                    :source_id, :source_type, :status, :transaction_type

      ENDPOINT = '/financial_transactions'

      # Fetches all financial transactions using the API.
      #
      # @param [Hash] options
      # @options [String] :batch_id - Batch ID of the financial transaction
      # @options [String] :currency - The currency (3-letter ISO-4217 code) of the financial transaction
      # @options [String] :from_created_at - The start time of created_at in ISO8601 format (inclusive)
      # @options [String] :source_id - The source ID of the transaction
      # @options [String] :status - Status of the financial transaction, one of: PENDING, SETTLED
      # @options [String] :to_created_at - The end time of created_at in ISO8601 format (inclusive)
      # @options [Integer] :page_num - Page number, starts from 0
      # @options [Integer] :page_size - Number of results per page, default is 100, max is 1000
      # @return [Array<AirwallexRuby::FinancialTransaction>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a financial transaction using the API.
      #
      # @param [String] financial_transaction_id the Financial Transaction Id
      # @return [AirwallexRuby::FinancialTransaction]
      def self.find(financial_transaction_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{financial_transaction_id}" 
        end

        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end
      # End of FinancialTransaction class
    end
  end
end
