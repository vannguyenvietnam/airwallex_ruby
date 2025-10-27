module AirwallexRuby
  module Model
    class Refund < Base
      attr_accessor :refund_transaction_id, :amount, :tax_amount, :reason, :cancel_subscriptions,
                    :vendors_refund_info, :transaction_meta_data

      ENDPOINT = '/services/2/transactions/refund'
      ENDPOINT_PENDING = '/services/2/transactions/pending-refund'

      # Uses the API to create a refund for a Transaction.
      #
      # @param [Hash] refund_data - Details here https://developers.airwallex.com/v8976-JSON/reference/refund
      # @return [AirwallexRuby::Refund]
      def self.create transaction_id, refund_data, options = {}
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path = "#{ENDPOINT}/#{transaction_id}"
          uri.path = "#{ENDPOINT}/merchant/#{transaction_id}" if options[:using_merchant_id]
        end

        response = post(request_url)
        response_body = JSON.parse(response.body)
        new(response_body)
      end

      # Uses the API to cancel a pending refund for a Transaction.
      #
      # @param [String] transaction_id
      # @return [AirwallexRuby::Refund]
      def self.cancel_pending_refund transaction_id, options = {}
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path = "#{ENDPOINT_PENDING}/#{transaction_id}"
          uri.path = "#{ENDPOINT_PENDING}/merchant/#{transaction_id}" if options[:using_merchant_id]
        end

        response = delete(request_url)
        response.code.to_i == 200
      end
    end
  end
end
