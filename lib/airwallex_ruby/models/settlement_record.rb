module AirwallexRuby
  module Model
    class SettlementRecord < Base
      attr_accessor :account_id, :acquirer_reference_number, :card_category, :card_funding, 
                    :card_issuing_or_shopper_country, :card_transaction_region, :connected_account_id,
                    :created_at, :customer_email, :customer_id, :customer_name, :customer_phone, :descriptor,
                    :dispute_reason, :dispute_reason_code, :dispute_status, :exchange_rate, :fee_details_list,
                    :fees, :gross_amount, :issuing_or_originating_bank, :merchant_customer_id, :metadata,
                    :net_amount, :order_id, :payment_attempt_ids, :payment_created_time, :payment_intent_id,
                    :payment_link_reference, :payment_method, :payment_method_type, :request_id, :settled_at,
                    :settlement_batch_id, :settlement_currency, :shipping_address, :shipping_city, :shipping_country,
                    :shipping_name, :shipping_postal_code, :shipping_state, :source_entity, :source_id, 
                    :subscription_id, :taxes_on_fees, :transaction_amount, :transaction_currency, :transaction_id,
                    :transaction_type

      ENDPOINT = '/pa/settlement_records'

      # Fetches all customers using the API.
      #
      # @param [Hash] options
      # @options [String] :payment_intent_id - The payment intent ID of the settlement records
      # @options [String] :settlement_id - The settlement(batch) ID of the settlement records
      # @options [String] :page - Value from page_after
      # @options [Integer] :page_size - The number of items requested by page (default and max is 50)
      # @return [Array<AirwallexRuby::SettlementRecord>] List of SettlementRecord objects.
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end
      # End of SettlementRecord class
    end
  end
end
