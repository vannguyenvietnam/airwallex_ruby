module AirwallexRuby
  module Model
    class Account < Base
      attr_accessor :id, :identifier, :account_details, :created_at, :customer_agreements, :metadata,
                    :next_action, :nickname, :primary_contact, :reactivate_details, :requirements, :status,
                    :suspend_details, :view_type

      ENDPOINT = '/accounts'

      # Uses the API to create a connected account for vendor.
      #
      # @param [Hash] account_data
      # @option account_data [Hash] :account_details *required*
      # @option account_data [Hash] :customer_agreements *required*
      # @option account_data [Hash] :primary_contact *required*
      # @return [AirwallexRuby::Account]
      def self.create account_data
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, account_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Update an account using the API.
      #
      # @param [String] account_id *required*
      # @param [Hash] account_data *required*
      # @return [AirwallexRuby::Account]
      def self.update account_id, account_data
        temp_account = new(id: account_id)
        temp_account.update(account_data)
      end

      # Fetches all of your Accounts using the API.
      #
      # @param [Hash] options
      # @options [Integer] :pagesize Positive integer. Default is 10 if not set. Maximum is 500.
      # @options [TrueClass] :gettotal true = Include the number of total results in the response.
      # @options [Account ID] :after Account ID. The response will get the page of results after the specified ID (exclusive).
      # @options [Account ID] :before Account ID. The response will get the page of results before the specified ID (exclusive).
      # @return [Array<AirwallexRuby::Account>]
      def self.all options = {}
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        params_text = options.map { |k, v| "#{k}=#{ERB::Util.url_encode(v.to_s)}" }.join("\&")
        request_url.query = params_text
        response = get(request_url)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches an account using the API.
      #
      # @param [String] account_id the Account Id
      # @return [AirwallexRuby::Account]
      def self.find account_id
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{account_id}" }
        response = get(request_url)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Submit an account for activation using the API.
      #
      # @param [String] account_id the Account Id
      # @return [AirwallexRuby::Account]
      def self.submit account_id
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{account_id}/submit" }
        response = post(request_url)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Update an Account using the API.
      #
      # @param [Hash] account_data
      # @return [AirwallexRuby::Account]
      def update account_data
        attributes = self.class.attributes - [:id]
        options = self.class.parse_body_for_request(attributes, account_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{id}/update" }
        response = self.class.put(request_url, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end
    end
  end
end
