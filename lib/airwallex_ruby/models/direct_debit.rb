module AirwallexRuby
  module Model
    class DirectDebit < Base
      attr_accessor :id, :amount, :created_at, :currency, :transaction_id, :global_account_id, :status,
                    :debtor_name, :statement_ref, :mandate_id

      ENDPOINT = '/direct_debits'

      # Fetches all direct debits using the API.
      #
      # @param [Hash] options
      # @options [String] :from_created_date - The start date of created_at in ISO8601 format (inclusive)
      # @options [String] :to_created_date - The end date of created_at in ISO8601 format (inclusive)
      # @options [Integer] :page_num - Page number, starts from 0.
      # @options [Integer] :page_size - Number of results per page, defaultValue 100
      # @return [Array<AirwallexRuby::DirectDebit>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a direct debit using the API.
      #
      # @param [String] direct_debit_id the Direct Debit Id
      # @return [AirwallexRuby::DirectDebit]
      def self.find(direct_debit_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{direct_debit_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Cancel a direct debit using the API.
      #
      # @param [String] direct_debit_id the Direct Debit Id
      # @return [TrueClass|FalseClass]
      def self.cancel(direct_debit_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{direct_debit_id}/cancel" 
        end

        response = post(request_url, {}, options.merge(raw_response: true))
        response.code.to_s == '200'
      end
      # End of DirectDebit class
    end
  end
end
