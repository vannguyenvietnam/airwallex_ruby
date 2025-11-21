module AirwallexRuby
  module Model
    class FinancialReport < Base
      attr_accessor :id, :file_format, :file_name, :report_expires_at, :report_parameters, :report_version, :status,
                    :type

      ENDPOINT = '/finance/financial_reports'

      # Uses the API to create a financial report.
      #
      # @param [Hash] financial_report_data
      # @option financial_report_data [String] :file_format *required*
      # @option financial_report_data [String] :from_date *required*
      # @option financial_report_data [String] :to_date *required*
      # @option financial_report_data [String] :type *required*
      # @return [AirwallexRuby::FinancialReport]
      def self.create(financial_report_data, options = {})
        attributes = %w[
          currencies file_format file_name from_date report_version settlement_currencies statuses
          time_zone to_date transaction_types type
        ] # fix attributes allowed by POST API
         
        request_body = parse_body_for_request(attributes, financial_report_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Fetches all financial reports using the API.
      #
      # @param [Hash] options
      # @options [Integer] :page_num - Page number, starts from 0.
      # @options [Integer] :page_size - Number of results per page, default is 100, max is 1000
      # @return [Array<AirwallexRuby::FinancialReport>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a financial report using the API.
      #
      # @param [String] financial_report_id the Financial Report Id
      # @return [AirwallexRuby::FinancialReport]
      def self.find(financial_report_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{financial_report_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Generate client secret for a customer for activation using the API.
      #
      # @param [String] financial_report_id the Financial Report Id
      # @return [HTTP::Response] raw response containing the financial report content
      def self.content(financial_report_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{financial_report_id}/content" 
        end

        get(request_url, {}, options.merge(raw_response: true, file: true))
      end
      # End of FinancialReport class
    end
  end
end
