module BluesnapRuby
  class AltTransaction < Base
    attr_accessor :transaction_id, :merchant_transaction_id, :soft_descriptor, :amount, :currency, 
                  :tax_reference, :vendors_info, :payer_info, :vaulted_shopper_id, :pf_token,
                  :ecp_transaction, :authorized_by_shopper, :transaction_meta_data, :transaction_fraud_info, 
                  :processing_info, :fraudResult_info, :transaction_approval_date, 
                  :transaction_approval_time, :refunds, :transaction_order_source

    ENDPOINT = '/services/2/alt-transactions'

    # Uses the API to create a alt Transaction.
    #
    # @param [Hash] transaction_data
    # @return [BluesnapRuby::AltTransaction]
    def self.create transaction_data
      attributes = self.attributes - [:transaction_id] # fix attributes allowed by POST API
      request_body = parse_body_for_request(attributes, transaction_data)
      request_url = URI.parse(BluesnapRuby.api_url).tap { |uri| uri.path = ENDPOINT }
      response = post(request_url, request_body)
      response_body = JSON.parse(response.body)
      new(response_body)
    end

    # Fetches a alt Transaction using the API.
    #
    # @param [String] transaction_id the TransactionId or {merchantTransactionId},{merchantId}
    # @return [BluesnapRuby::AltTransaction]
    def self.find transaction_id
      request_url = URI.parse(BluesnapRuby.api_url).tap do |uri| 
        uri.path = "#{ENDPOINT}/#{transaction_id}"
      end

      response = get(request_url)
      response_body = JSON.parse(response.body)
      new(response_body)
    end
  end
end
