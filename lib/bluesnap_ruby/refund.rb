module BluesnapRuby
  class Refund < Base
    attr_accessor :refund_transaction_id, :amount, :tax_amount, :reason, :cancel_subscriptions,
                  :vendors_refund_info, :transaction_meta_data

    ENDPOINT = '/services/2/transactions/refund'

    # Uses the API to create a refund for a Transaction.
    #
    # @param [Hash] refund_data - Details here https://developers.bluesnap.com/v8976-JSON/reference/refund
    # @return [BluesnapRuby::Refund]
    def self.create transaction_id, refund_data, options = {}
      request_url = URI.parse(BluesnapRuby.api_url).tap do |uri| 
        uri.path = "#{ENDPOINT}/#{transaction_id}"
        uri.path = "#{ENDPOINT}/merchant/#{transaction_id}" if options[:using_merchant_id]
      end

      response = post(request_url)
      response_body = JSON.parse(response.body)
      new(response_body)
    end
  end
end
