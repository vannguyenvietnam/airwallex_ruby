module AirwallexRuby
  module Model
    class ConnectedAccountTransfer < Base
      attr_accessor :id, :additional_info, :amount, :created_at, :currency, :destination, :fee,
                    :reason, :reference, :request_id, :short_reference_id, :status, :updated_at

      ENDPOINT = '/connected_account_transfers'

      # Uses the API to create a connected account transfer.
      #
      # @param [Hash] connected_account_transfer_data
      # @option connected_account_transfer_data [String] :amount *required*
      # @option connected_account_transfer_data [String] :currency *required*
      # @option connected_account_transfer_data [String] :destination *required*
      # @option connected_account_transfer_data [String] :reason *required*
      # @option connected_account_transfer_data [String] :reference *required*
      # @option connected_account_transfer_data [String] :request_id *required*
      # @return [AirwallexRuby::ConnectedAccountTransfer]
      def self.create(connected_account_transfer_data, options = {})
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, connected_account_transfer_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Fetches all connected account transfers using the API.
      #
      # @param [Hash] options
      # @options [String] :currency - Currency (3-letter ISO-4217 code)
      # @options [String] :destination - Airwallex account ID
      # @options [String] :from_created_at - The start date of created_at in ISO8601 format (inclusive)
      # @options [String] :request_id - Transfer request_id
      # @options [String] :status - Status of the transfer. One of: NEW, SETTLED, PENDING, SUSPENDED, FAILED
      # @options [String] :to_created_at - The end date of created_at in ISO8601 format (inclusive)
      # @options [Integer] :page_num - Page number, starts from 0.
      # @options [Integer] :page_size - Number of results per page. Default value is 100, minimum 10, maximum 2000
      # @return [Array<AirwallexRuby::ConnectedAccountTransfer>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a connected account transfer using the API.
      #
      # @param [String] connected_account_transfer_id the Connected Account Transfer Id
      # @return [AirwallexRuby::ConnectedAccountTransfer]
      def self.find(connected_account_transfer_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{connected_account_transfer_id}" 
        end

        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end
      # End of ConnectedAccountTransfer class
    end
  end
end
