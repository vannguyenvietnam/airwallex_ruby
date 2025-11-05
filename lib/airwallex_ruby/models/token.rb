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
        response = post(request_url)
        response_body = JSON.parse(response.body)
        new(response_body)
      end

      # Uses the API to authorize an account.
      #
      # @return [AirwallexRuby::Token]
      def self.authorize_account(authorize_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/authorize" }
        connected_account_id = authorize_data.delete(:connected_account_id)
        response = post(request_url, authorize_data, on_behalf_of: connected_account_id)
        response_body = JSON.parse(response.body)
        new(response_body)
      end
    end
  end
end
