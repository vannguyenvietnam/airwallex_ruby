module AirwallexRuby
  module Model
    class Balance < Base
      attr_accessor :available_amount, :currency, :pending_amount, :prepayment_amount, :reserved_amount,
                    :total_amount

      ENDPOINT = '/balances'

      # Fetches current balance using the API.
      #
      # @return [AirwallexRuby::Balance]
      def self.current
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/current" }
        response = get(request_url)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Fetches balance history using the API.
      #
      # @return [AirwallexRuby::Balance]
      def self.history
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/history" }
        response = get(request_url)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end
    end
  end
end
