module AirwallexRuby
  module Model
    class Account < Base
      attr_accessor :id, :status, :requirements, :account_details, :customer_agreements,
                    :primary_contact

      ENDPOINT = '/accounts'

      # Uses the API to create a connected account for vendor.
      #
      # @param [Hash] account_data
      # @option account_data [Hash] :account_details *required*
      # @option account_data [Hash] :customer_agreements *required*
      # @option account_data [Hash] :primary_contact *required*
      # @return [AirwallexRuby::Account]
      def self.create account_data
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, account_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        response = post(request_url, request_body)
        return nil if response.header['location'].nil?

        location = response.header['location']
        location.split('/').last
      end

      # Update a vendor using the API.
      #
      # @param [String] vendor_id *required*
      # @param [Hash] vendor_data *required*
      # @return [AirwallexRuby::Vendor]
      def self.update vendor_id, vendor_data
        temp_vendor = new(vendor_id: vendor_id)
        temp_vendor.update(vendor_data)
      end

      # Fetches all of your Vendors using the API.
      #
      # @param [Hash] options
      # @options [Integer] :pagesize Positive integer. Default is 10 if not set. Maximum is 500.
      # @options [TrueClass] :gettotal true = Include the number of total results in the response.
      # @options [Vendor ID] :after Vendor ID. The response will get the page of results after the specified ID (exclusive).
      # @options [Vendor ID] :before Vendor ID. The response will get the page of results before the specified ID (exclusive).
      # @return [Array<AirwallexRuby::Vendor>]
      def self.all options = {}
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path = ENDPOINT }
        params_text = options.map { |k, v| "#{k}=#{ERB::Util.url_encode(v.to_s)}" }.join("\&")
        request_url.query = params_text
        response = get(request_url)
        response_body = JSON.parse(response.body)
        return [] if response_body['vendor'].nil?

        response_body['vendor'].map { |item| new(item) }
      end

      # Fetches a vendor using the API.
      #
      # @param [String] vendor_id the Vendor Id
      # @return [AirwallexRuby::Vendor]
      def self.find vendor_id
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path = "#{ENDPOINT}/#{vendor_id}" }
        response = get(request_url)
        response_body = JSON.parse(response.body)
        new(response_body)
      end

      # Update a Vendor using the API.
      #
      # @param [Hash] vendor_data
      # @return [AirwallexRuby::Vendor]
      def update vendor_data
        attributes = self.class.attributes - [:vendor_id]
        options = self.class.parse_body_for_request(attributes, vendor_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path = "#{ENDPOINT}/#{vendor_id}" }
        response = self.class.put(request_url, options)
        response.code.to_s == '204'
      end
    end
  end
end
