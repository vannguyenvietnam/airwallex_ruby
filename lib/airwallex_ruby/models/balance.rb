module AirwallexRuby
  module Model
    class Balance < Base
      attr_accessor :available_amount, :currency, :pending_amount, :prepayment_amount, :reserved_amount,
                    :total_amount

      ENDPOINT = '/balances'

      # Fetches current balance using the API.
      #
      # @return [AirwallexRuby::Balance]
      def self.current(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/current" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return new(response_body.deep_symbolize_keys) unless response_body.is_a?(Array)

        response_body.map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches balance history using the API.
      #
      # @return [AirwallexRuby::Balance]
      def self.history(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/history" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end
    end
  end
end
