module AirwallexRuby
  module Model
    class Beneficiary < Base
      attr_accessor :id, :beneficiary, :nickname, :payer_entity_type, :sca_exemptible, :transfer_methods,
                    :transfer_reason

      ENDPOINT = '/beneficiaries'

      # Uses the API to create a connected beneficiary.
      #
      # @param [Hash] beneficiary_data
      # @option beneficiary_data [Hash] :beneficiary *required*
      # @option beneficiary_data [Hash] :transfer_methods *required*
      # @return [AirwallexRuby::Beneficiary]
      def self.create beneficiary_data
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, beneficiary_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Update a beneficiary using the API.
      #
      # @param [String] beneficiary_id *required*
      # @param [Hash] beneficiary_data *required*
      # @return [AirwallexRuby::Beneficiary]
      def self.update beneficiary_id, beneficiary_data
        temp_account = new(id: beneficiary_id)
        temp_account.update(beneficiary_data)
      end

      # Fetches all of your Beneficiaries using the API.
      #
      # @param [Hash] options
      # @options [Integer] :pagesize Positive integer. Default is 10 if not set. Maximum is 500.
      # @options [TrueClass] :gettotal true = Include the number of total results in the response.
      # @options [Beneficiary ID] :after Beneficiary ID. The response will get the page of results after the specified ID (exclusive).
      # @options [Beneficiary ID] :before Beneficiary ID. The response will get the page of results before the specified ID (exclusive).
      # @return [Array<AirwallexRuby::Beneficiary>]
      def self.all options = {}
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        params_text = options.map { |k, v| "#{k}=#{ERB::Util.url_encode(v.to_s)}" }.join("\&")
        request_url.query = params_text
        response = get(request_url)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a beneficiary using the API.
      #
      # @param [String] beneficiary_id the Beneficiary Id
      # @return [AirwallexRuby::Beneficiary]
      def self.find beneficiary_id
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{beneficiary_id}" }
        response = get(request_url)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Update a Beneficiary using the API.
      #
      # @param [Hash] beneficiary_data
      # @return [AirwallexRuby::Beneficiary]
      def update beneficiary_data
        attributes = self.class.attributes - [:id]
        options = self.class.parse_body_for_request(attributes, beneficiary_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{id}/update" }
        response = self.class.put(request_url, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end
    end
  end
end
