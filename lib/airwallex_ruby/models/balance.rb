module AirwallexRuby
  module Model
    class Balance < Base
      attr_accessor :available_amount, :currency, :pending_amount, :prepayment_amount, :reserved_amount,
                    :total_amount

      ENDPOINT = '/balances'

      # Fetches current balance using the API.
      #
      # @return [Array<AirwallexRuby::Balance>] List of Balance objects representing current balances.
      def self.current(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/current" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return new(response_body.deep_symbolize_keys) unless response_body.is_a?(Array)

        response_body.map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches balance history using the API.
      #
      # @param [Hash] options
      # @options [String] :currency -The transaction currency in 3-letter ISO-4217 format.
      # @options [String] :from_post_at - The start date (inclusive) of the date range during which balance activity occurred in your Wallet. Specify the date in ISO8601 format. If not specified, from_post_at defaults to 7 days before to_post_at.
      # @options [String] :request_id - request_id from clients for the transaction
      # @options [String] :to_post_at - The end date (exclusive) of the date range during which the balance activity occurred in your Wallet. Specify the date in ISO8601 format. Defaults to today if neither this field nor from_post_at are specified. If from_post_at is specified, then to_post_at defaults to 7 days after the from_post_at date.
      # @options [String] :page - A bookmark for use in pagination to retrieve either the next page or the previous page of results. You can fetch the value for this identifier from the response of the previous API call. To retrieve the next page of results, pass the value of page_after (if not null) from the response to a subsequent call. To retrieve the previous page of results, pass the value of page_before (if not null) from the response to a subsequent call. Passing page=0 will override the 7 day default for null date ranges, enabling a complete search of the Wallet balance records.
      # @options [Integer] :page_num - The page number of the page to be retrieved. Page numbers range from 0 to a maximum value of 10000.
      # @options [Integer] :page_size - A limit on the number of records to be returned on a page, between 10 and 2000. The default is 100.
      # @return [Array<Hash>]
      def self.history(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/history" }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| item.deep_symbolize_keys }
      end
    end
  end
end
