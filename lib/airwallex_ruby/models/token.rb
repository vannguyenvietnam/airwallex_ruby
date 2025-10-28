module AirwallexRuby
  module Model
    class Token < Base
      attr_accessor :token, :expires_at

      ENDPOINT = '/authentication/login'

      # Uses the API to obtain a token.
      #
      # @return [AirwallexRuby::Token]
      def self.fetch_token
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri|
          uri.path += ENDPOINT
        end

        response = post(request_url)
        response_body = JSON.parse(response.body)
        new(response_body)
      end
    end
  end
end
