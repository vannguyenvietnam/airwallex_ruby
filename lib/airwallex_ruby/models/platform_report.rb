module AirwallexRuby
  module Model
    class PlatformReport < Base
      attr_accessor :id, :download_url, :download_url_expires_at, :failed_reason, :file_format, :file_name,
                    :from_created_at, :from_updated_at, :status, :to_created_at, :to_updated_at, :type

      ENDPOINT = '/platform_reports'

      # Uses the API to create a platform report.
      #
      # @param [Hash] platform_report_data
      # @option platform_report_data [String] :file_format *required*
      # @option platform_report_data [String] :type *required*
      # @return [AirwallexRuby::PlatformReport]
      def self.create(platform_report_data, options = {})
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, platform_report_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Fetches a platform report using the API.
      #
      # @param [String] platform_report_id the Platform Report Id
      # @return [AirwallexRuby::PlatformReport]
      def self.find(platform_report_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{platform_report_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end
      # End of PlatformReport class
    end
  end
end
