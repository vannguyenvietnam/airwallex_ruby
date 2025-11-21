module AirwallexRuby
  module Model
    class Settlement < Base
      attr_accessor :id, :amount, :created_at, :currency, :estimated_settled_at, :fee, :settled_at,
                    :status

      ENDPOINT = '/pa/financial/settlements'

      # Fetches all settlements using the API.
      #
      # @param [Hash] options
      # @options [String] :currency - Currency of the settlement
      # @options [String] :from_settled_at - The start date of settled_at in ISO8601 format (inclusive)
      # @options [String] :status - Status of the settlement, one of: PENDING, SETTLED
      # @options [String] :to_settled_at - The end date of settled_at in ISO8601 format (inclusive)
      # @options [Integer] :page_num - Page number, starts from 0.
      # @options [Integer] :page_size - Number of results per page, default is 100, max is 1000
      # @return [Array<AirwallexRuby::Settlement>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a settlement using the API.
      #
      # @param [String] settlement_id the Settlement Id
      # @return [AirwallexRuby::Settlement]
      def self.find(settlement_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{settlement_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Fetches a report using the API.
      #
      # @options [String] :file_format - File format of the requested report (Not applicable to version 1.0.0). Supported formats are csv and excel. Default format is excel.
      # @options [String] :version - Version of the report: 1.0.0 (default) and 1.1.0 (recommended based on latest settlement report version)
      # @param [String] settlement_id the Settlement Id
      # @return [AirwallexRuby::Settlement]
      def self.report(settlement_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{settlement_id}/report" 
        end

        response = get(request_url, {}, options)
        JSON.parse(response.body).deep_symbolize_keys
      end
      # End of Settlement class
    end
  end
end
