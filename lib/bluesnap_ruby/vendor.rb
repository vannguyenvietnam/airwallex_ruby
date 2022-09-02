module BluesnapRuby
  class Vendor < Base
    attr_accessor :vendor_id, :email, :name, :ipn_url, :first_name, :last_name, :address, :city,
                  :zip, :country, :phone, :state, :default_payout_currency, :frequency, :delay,
                  :vendor_principal, :payout_info, :vendor_agreement, :verification

    ENDPOINT = '/services/2/vendors'

    # Uses the API to create a vendor.
    #
    # @param [Hash] vendor_data
    # @option vendor_data [String] :email *required*
    # @option vendor_data [String] :country *required*
    # @option vendor_data [Hash] :payout_info 
    # @return [BluesnapRuby::Vendor]
    def self.create vendor_data
      attributes = self.attributes - [:vendor_id] # fix attributes allowed by POST API
      options = parse_options_for_request(attributes, vendor_data)
      request_url = URI.parse(BluesnapRuby.api_url).tap { |uri| uri.path = Vendor::ENDPOINT }
      response = post(request_url, options)
      new(response)
    end

    # Update a vendor using the API.
    #
    # @param [String] vendor_id *required*
    # @param [Hash] vendor_data *required*
    # @return [BluesnapRuby::Vendor]
    def self.update vendor_id, vendor_data
      new(vendor_id: vendor_id).tap { |v| v.update(vendor_data) }
    end

    # Fetches all of your Vendors using the API.
    #
    # @param [Hash] options
    # @options [Integer] :pagesize Positive integer. Default is 10 if not set. Maximum is 500.
    # @options [TrueClass] :gettotal true = Include the number of total results in the response.
    # @options [Vendor ID] :after Vendor ID. The response will get the page of results after the specified ID (exclusive).
    # @options [Vendor ID] :before Vendor ID. The response will get the page of results before the specified ID (exclusive).
    # @return [Array<BluesnapRuby::Vendor>]
    # TODO: pagination
    def self.all options = {}
      request_uri = URI.parse(BluesnapRuby.api_url).tap { |uri| uri.path = Vendor::ENDPOINT }
      params_text = options.map { |k, v| "#{k}=#{ERB::Util.url_encode(v.to_s)}" }.join("\&")
      request_uri.query = params_text
      response = get(request_uri)
      response.map { |item| new(item) }
    end

    # Fetches a customer using the API.
    #
    # @param [String] vendor_id the Vendor Id
    # @return [BluesnapRuby::Vendor]
    def self.find vendor_id
      request_uri = URI.parse(BluesnapRuby.api_url).tap { |uri| uri.path = "#{Vendor::ENDPOINT}/#{vendor_id}" }
      response = get(request_uri)
      new(response)
    end

    # Update a Vendor using the API.
    #
    # @param [Hash] vendor_data
    # @return [BluesnapRuby::Vendor]
    def update vendor_data
      attributes = self.class.attributes - [:vendor_id]
      options = self.class.parse_options_for_request(attributes, vendor_data)
      request_uri = URI.parse(BluesnapRuby.api_url).tap { |uri| uri.path = "#{Vendor::ENDPOINT}/#{vendor_id}" }
      response = self.class.put(request_uri, options)
      new(response)
    end
  end
end
