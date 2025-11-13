module AirwallexRuby
  module Model
    class Token < Base
      attr_accessor :token, :expires_at, :authorization_code

      ENDPOINT = '/authentication'

      # Uses the API to obtain a token.
      #
      # @return [AirwallexRuby::Token]
      def self.fetch_token
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/login" }
        response = post(request_url, {}, use_client_id: true)
        response_body = JSON.parse(response.body)
        new(response_body)
      end

      # Uses the API to authorize an account.
      #
      # @return [AirwallexRuby::Token]
      def self.authorize_account(authorize_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/authorize" }
        response = post(request_url, authorize_data, options)
        response_body = JSON.parse(response.body)
        new(response_body)
      end
    end
  end
end
