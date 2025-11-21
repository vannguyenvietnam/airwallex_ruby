module AirwallexRuby
  module Model
    class Charge < Base
      attr_accessor :id, :amount, :created_at, :currency, :fee, :reason, :reference, :request_id,
                    :short_reference_id, :source, :status, :updated_at

      ENDPOINT = '/charges'

      # Uses the API to create a charge.
      #
      # @param [Hash] customer_data
      # @option customer_data [String] :amount *required*
      # @option customer_data [String] :currency *required*
      # @option customer_data [String] :reason *required*
      # @option customer_data [String] :reference *required*
      # @option customer_data [String] :request_id *required*
      # @option customer_data [String] :source *required*
      # @return [AirwallexRuby::Charge]
      def self.create(charge_data, options = {})
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, charge_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Fetches all charges using the API.
      #
      # @param [Hash] options
      # @options [String] :currency - Currency (3-letter ISO-4217 code)
      # @options [String] :from_created_at - The start date of created_at in ISO8601 format (inclusive)
      # @options [String] :request_id - Charge request_id
      # @options [String] :source - Airwallex account ID
      # @options [String] :status - Status of the charge, one of: NEW, PENDING, SETTLED,SUSPENDED, FAILED
      # @options [String] :to_created_at - The end date of created_at in ISO8601 format (inclusive)
      # @options [Integer] :page_num - Page number, starts from 0.
      # @options [Integer] :page_size - Number of results per page. Default value is 100, minimum 10, maximum 2000
      # @return [Array<AirwallexRuby::Charge>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a charge using the API.
      #
      # @param [String] charge_id the Charge Id
      # @return [AirwallexRuby::Charge]
      def self.find(charge_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{charge_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end
      # End of Charge class
    end
  end
end
