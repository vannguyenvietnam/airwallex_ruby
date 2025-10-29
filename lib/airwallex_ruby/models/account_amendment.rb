module AirwallexRuby
  module Model
    class AccountAmendment < Base
      attr_accessor :id, :primary_contact, :status, :store_details, :target

      ENDPOINT = '/accounts/amendments'

      # Uses the API to create an account amendment for marketplace account.
      #
      # @param [Hash] account_amendment_data
      # @option account_amendment_data [Hash] :account_details *required*
      # @option account_amendment_data [Hash] :customer_agreements *required*
      # @option account_amendment_data [Hash] :primary_contact *required*
      # @return [AirwallexRuby::AccountAmendment]
      def self.create account_amendment_data
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, account_amendment_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Fetches an account amendment using the API.
      #
      # @param [String] account_amendment_id the Account Amendment Id
      # @return [AirwallexRuby::AccountAmendment]
      def self.find account_amendment_id
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{account_amendment_id}" }
        response = get(request_url)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end
    end
  end
end
