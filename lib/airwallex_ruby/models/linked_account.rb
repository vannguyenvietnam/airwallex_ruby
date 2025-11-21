module AirwallexRuby
  module Model
    class LinkedAccount < Base
      attr_accessor :id, :au_bank, :au_payid, :ca_bank, :capabilities, :eu_bank, :failure_details,
                    :gb_bank, :hk_bank, :next_action, :nz_bank, :reason, :sg_bank, :status,
                    :supported_currencies, :type, :us_bank

      ENDPOINT = '/linked_accounts'

      # Uses the API to create a linked account.
      #
      # @param [Hash] linked_account_data
      # @option linked_account_data [String] :type *required*
      # @option linked_account_data [String] :request_id *required*
      # @return [AirwallexRuby::LinkedAccount]
      def self.create(linked_account_data, options = {})
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, linked_account_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Fetches all linked accounts using the API.
      #
      # @param [Hash] options
      # @options [String] :country_code - The country where your Linked Account is located
      # @options [String] :from_created_at - The start date of created_at in ISO8601 format (inclusive). If null, response will provide Linked Accounts created in the past 31 days.
      # @options [String] :status - The status of the Linked Account. One of REQUIRES_ACTION, PROCESSING, SUCCEEDED, FAILED, SUSPENDED
      # @options [String] :to_created_at - The end date of created_at in ISO8601 format (inclusive). If null, response will provide Linked Accounts created in the past 31 days.
      # @options [Integer] :page_num - Page number, starts from 0
      # @options [Integer] :page_size - Number of results per page. Default value is 100
      # @return [Array<AirwallexRuby::LinkedAccount>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a linked account using the API.
      #
      # @param [String] linked_account_id the Linked Account Id
      # @return [AirwallexRuby::LinkedAccount]
      def self.find(linked_account_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{linked_account_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Generate authentication for a linked account using the API.
      #
      # @param [Hash] auth_data the OAuth data
      # @return [Hash]
      def self.auth(auth_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/auth" 
        end

        response = post(request_url, auth_data, options)
        JSON.parse(response.body).deep_symbolize_keys
      end

      # Refresh authentication for a linked account using the API.
      #
      # @param [String] linked_account_id the Linked Account Id
      # @return [Hash]
      def self.refresh_auth(linked_account_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{linked_account_id}/auth" 
        end

        response = post(request_url, {}, options)
        JSON.parse(response.body).deep_symbolize_keys
      end

      # Complete authentication for a linked account using the API.
      #
      # @param [String] linked_account_id the Linked Account Id
      # @return [Boolean]
      def self.complete_auth(linked_account_id, auth_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{linked_account_id}/complete_auth" 
        end

        response = post(request_url, auth_data, options.merge(raw_response: true))
        response.code.to_i == 200
      end

      # Generate client secret for a customer for activation using the API.
      #
      # @param [String] linked_account_id the Linked Account Id
      # @param [Hash] deposit_data the deposit data
      # @return [AirwallexRuby::LinkedAccount]
      def self.verify_microdeposits(linked_account_id, deposit_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{linked_account_id}/verify_microdeposits" 
        end

        response = post(request_url, deposit_data, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Fetch mandate for a linked account using the API.
      #
      # @param [String] linked_account_id the Linked Account Id
      # @return [Hash]
      def self.mandate(linked_account_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{linked_account_id}/mandate" 
        end

        response = get(request_url, {}, options)
        JSON.parse(response.body).deep_symbolize_keys
      end

      # Update mandate for a linked account using the API.
      #
      # @param [String] linked_account_id the Linked Account Id
      # @param [Hash] mandate_data the mandate data
      # @return [Hash]
      def self.update_mandate(linked_account_id, mandate_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{linked_account_id}/mandate" 
        end

        response = post(request_url, mandate_data, options)
        JSON.parse(response.body).deep_symbolize_keys
      end

      # Fetch balances for a linked account using the API.
      #
      # @param [String] linked_account_id the Linked Account Id
      # @return [Array<Hash>]
      def self.balances(linked_account_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{linked_account_id}/balances" 
        end

        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| item.deep_symbolize_keys }
      end

      # Suspend a linked account using the API.
      #
      # @param [String] linked_account_id the Linked Account Id
      # @return [Boolean]
      def self.suspend(linked_account_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{linked_account_id}/suspend" 
        end

        response = post(request_url, {}, options.merge(raw_response: true))
        response.code.to_i == 200
      end

      # Confirm a linked account using the API.
      #
      # @param [String] linked_account_id the Linked Account Id
      # @return [Boolean]
      def self.confirm(linked_account_id, confirm_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{linked_account_id}/confirm" 
        end

        response = post(request_url, confirm_data, options.merge(raw_response: true))
        response.code.to_i == 200
      end
      # End of LinkedAccount class
    end
  end
end
