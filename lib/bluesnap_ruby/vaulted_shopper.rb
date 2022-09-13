module BluesnapRuby
  class VaultedShopper < Base
    attr_accessor :vaulted_shopper_id, :payment_sources, :first_name, :last_name, :soft_descriptor, 
                  :descriptor_phone_number, :merchant_shopper_id, :country, :state, :city, :address,
                  :address2, :email, :zip, :phone, :company_name, :shopper_currency, 
                  :shipping_contact_info, :wallet_id, :transaction_fraud_info, :transaction_order_source, 
                  :three_d_secure

    ENDPOINT = '/services/2/vaulted-shoppers'

    # Uses the API to create a shopper.
    #
    # @param [Hash] shopper_data
    # @return [BluesnapRuby::VaultedShopper]
    def self.create shopper_data
      attributes = self.attributes - [:vaulted_shopper_id] # fix attributes allowed by POST API
      request_body = parse_body_for_request(attributes, shopper_data)
      request_url = URI.parse(BluesnapRuby.api_url).tap { |uri| uri.path = Vendor::ENDPOINT }
      response = post(request_url, request_body)
      return nil if response.header['location'].nil?

      location = response.header['location']
      location.split('/').last
    end

    # Update a shopper using the API.
    #
    # @param [String] vaulted_shopper_id *required*
    # @param [Hash] shopper_data *required*
    # @return [BluesnapRuby::VaultedShopper]
    def self.update vaulted_shopper_id, shopper_data
      temp_shopper = new(vaulted_shopper_id: vaulted_shopper_id)
      temp_shopper.update(shopper_data)
    end

    # Fetches a Shopper using the API.
    #
    # @param [String] vaulted_shopper_id the Shopper Id
    # @param [Hash] options
    # @options [TrueClass] :using_merchant_id Delete shopper using merchant shopper id.
    # @return [BluesnapRuby::VaultedShopper]
    def self.find vaulted_shopper_id, options = {}
      request_url = URI.parse(BluesnapRuby.api_url).tap do |uri| 
        uri.path = "#{Vendor::ENDPOINT}/#{vaulted_shopper_id}"
        uri.path = "#{Vendor::ENDPOINT}/merchant/#{vaulted_shopper_id}" if options[:using_merchant_id]
      end

      response = get(request_url)
      response_body = JSON.parse(response.body)
      new(response_body)
    end

    # Delete a Shopper using the API.
    #
    # @param [String] vaulted_shopper_id the Shopper Id
    # @param [Hash] options
    # @options [TrueClass] :using_merchant_id Delete shopper using merchant shopper id.
    # @return [BluesnapRuby::VaultedShopper]
    def self.delete vaulted_shopper_id, options = {}
      request_url = URI.parse(BluesnapRuby.api_url).tap do |uri| 
        uri.path = "#{Vendor::ENDPOINT}/#{vaulted_shopper_id}" 
        uri.path = "#{Vendor::ENDPOINT}/merchant/#{vaulted_shopper_id}" if options[:using_merchant_id]
      end

      response = delete(request_url)
      response.code.to_s == '200'
    end

    # Update a Shopper using the API.
    #
    # @param [Hash] shopper_data
    # @return [BluesnapRuby::VaultedShopper]
    def update shopper_data
      attributes = self.class.attributes - [:vaulted_shopper_id]
      options = self.class.parse_body_for_request(attributes, shopper_data)

      request_url = URI.parse(BluesnapRuby.api_url).tap do |uri| 
        uri.path = "#{Vendor::ENDPOINT}/#{vaulted_shopper_id}" 
      end

      response = self.class.put(request_url, options)
      response.code.to_s == '204'
    end
  end
end
