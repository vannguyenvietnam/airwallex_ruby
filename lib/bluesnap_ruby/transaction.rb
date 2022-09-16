module BluesnapRuby
  class Transaction < Base
    attr_accessor :transaction_id, :wallet_id, :wallet, :amount, :usd_amount, :open_to_capture, 
                  :vaulted_shopper_id, :merchant_transaction_id, :soft_descriptor, 
                  :descriptor_phone_number, :tax_reference, :vendors_info, :card_holder_info, 
                  :currency, :transaction_fraud_info, :credit_card, :card_transaction_type, 
                  :three_d_secure, :transaction_meta_data, :pf_token, :level3_data, :store_card, 
                  :network_transaction_info, :transaction_order_source, :transaction_initiator,
                  :transaction_approval_date, :transaction_approval_time

    ENDPOINT = '/services/2/transactions'

    # Uses the API to create a Transaction.
    #
    # @param [Hash] transaction_data
    # @return [BluesnapRuby::Transaction]
    def self.create transaction_data
      attributes = self.attributes - [:transaction_id] # fix attributes allowed by POST API
      request_body = parse_body_for_request(attributes, transaction_data)
      request_url = URI.parse(BluesnapRuby.api_url).tap { |uri| uri.path = ENDPOINT }
      response = post(request_url, request_body)
      response_body = JSON.parse(response.body)
      new(response_body)
    end

    # Uses the API to create a auth capture Transaction.
    #
    # @param [Hash] transaction_data
    # @return [BluesnapRuby::Transaction]
    def self.auth_capture transaction_data
      transaction_data[:card_transaction_type] = 'AUTH_CAPTURE'
      create(transaction_data)
    end

    # Uses the API to create a auth only Transaction.
    #
    # @param [Hash] transaction_data
    # @return [BluesnapRuby::Transaction]
    def self.auth_only transaction_data
      transaction_data[:card_transaction_type] = 'AUTH_ONLY'
      create(transaction_data)
    end

    # Update a Transaction using the API.
    #
    # @param [String] transaction_id *required*
    # @param [Hash] transaction_data *required*
    # @return [BluesnapRuby::Transaction]
    def self.update transaction_id, transaction_data
      transaction_data[:transaction_id] = transaction_id
      attributes = self.attributes
      request_body = parse_body_for_request(attributes, transaction_data)
      request_url = URI.parse(BluesnapRuby.api_url).tap { |uri| uri.path = ENDPOINT }
      # Send request
      response = put(request_url, request_body)
      response_body = JSON.parse(response.body)
      new(response_body)
    end

    # Update a Transaction using the API.
    #
    # @param [String] transaction_id *required*
    # @param [Hash] transaction_data *required*
    # @return [BluesnapRuby::Transaction]
    def self.capture transaction_id, transaction_data
      transaction_data[:card_transaction_type] = 'CAPTURE'
      update(transaction_id, transaction_data)
    end

    # Auth reversal a Transaction using the API.
    #
    # @param [String] transaction_id the Transaction Id or merchant_transaction_id
    # @param [Hash] options
    # @options [TrueClass] :using_merchant_id if using merchant Transaction id.
    # @return [BluesnapRuby::Transaction]
    def self.auth_reversal transaction_id, options = {}
      id_field_name = options[:using_merchant_id] ? 'merchant_transaction_id' : 'transaction_id'

      request_body = { 
        card_transaction_type: 'AUTH_REVERSAL',
        "#{id_field_name}": transaction_id
      }

      update(transaction_id, request_body)
    end

    # Fetches a Transaction using the API.
    #
    # @param [String] transaction_id the TransactionId or {merchantTransactionId},{merchantId}
    # @return [BluesnapRuby::Transaction]
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
