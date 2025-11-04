module AirwallexRuby
  module Model
    class Token < Base
      include AirwallexRuby::Helpers

      attr_accessor :token, :expires_at, :authorization_code

      ENDPOINT = '/authentication'

      # Uses the API to obtain a token.
      #
      # @return [AirwallexRuby::Token]
      def self.fetch_token
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri|
          uri.path += "#{ENDPOINT}/login"
        end

        response = post(request_url)
        response_body = JSON.parse(response.body)
        new(response_body)
      end

      # Uses the API to authorize an account.
      #
      # @return [AirwallexRuby::Token]
      def self.authorize_account(connected_account_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri|
          uri.path += "#{ENDPOINT}/authorize"
        end

        request_body = {
          code_challenge: generate_code_challenge,
          identity: options[:identity],
          scope: [ 'w:awx_action:onboarding' ],
        }

        response = post(request_url, request_body, on_behalf_of: connected_account_id)
        response_body = JSON.parse(response.body)
        new(response_body)
      end
    end
  end
end
