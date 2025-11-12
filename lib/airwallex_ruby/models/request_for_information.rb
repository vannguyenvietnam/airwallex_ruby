module AirwallexRuby
  module Model
    class RequestForInformation < Base
      attr_accessor :id, :account_id, :active_request, :answered_requests, :created_at, :status, :sub_type, :type,
                    :updated_at

      ENDPOINT = '/rfis'

      # Fetches all rfis of your Accounts using the API.
      #
      # @param [Hash] options
      # @options [String] :end_created_at - The end date of created_at in ISO8601 format (inclusive)
      # @options [String] :from_created_at - The start date of created_at in ISO8601 format (inclusive)
      # @options [Array] :statuses - List of RFI status separated by ,. One of ACTION_REQUIRED, ANSWERED, CLOSED.
      # @options [Array] :types - List of RFI types separated by ,. Currently only supports KYC, KYC_ONGOING, CARDHOLDER, TRANSACTION and PAYMENT_ENABLEMENT types.
      # @options [String] :page - A bookmark for use in pagination to retrieve either the next page or the previous page of results. You can fetch the value for this identifier from the response of the previous API call. To retrieve the next page of results, pass the value of page_after (if not null) from the response to a subsequent call. To retrieve the previous page of results, pass the value of page_before (if not null) from the response to a subsequent call.
      # @options [Integer] :page_size - A limit on the number of records to be returned on a page, between 1 and 2000. The default is 100.
      # @return [Array<AirwallexRuby::RequestForInformation>]
      def self.all options = {}
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}" 
        end
        
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a Request For Information using the API.
      #
      # @param [String] rfi_id the Request For Information Id
      # @return [AirwallexRuby::RequestForInformation]
      def self.find rfi_id
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{rfi_id}" }
        response = get(request_url)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Responds to a Request For Information using the API.
      #
      # @param [String] rfi_id the Request For Information Id
      # @param [Array] rfi_response the response to the Request For Information. List of questions and answers.
      # @return [AirwallexRuby::RequestForInformation]
      def self.respond rfi_id, rfi_response
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri|
          uri.path += "#{ENDPOINT}/#{rfi_id}/respond"
        end

        response = post(request_url, rfi_response)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end
    end
  end
end
