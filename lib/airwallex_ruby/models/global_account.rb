module AirwallexRuby
  module Model
    class GlobalAccount < Base
      attr_accessor :id, :account_name, :account_number, :account_type, :alternate_account_identifiers, 
                    :close_reason, :country_code, :deposit_conversion_currency, :failure_reason, :iban,
                    :institution, :nick_name, :request_id, :required_features, :status, :supported_features,
                    :swift_code

      ENDPOINT = '/global_accounts'

      # Uses the API to create a global account.
      #
      # @param [Hash] global_account_data
      # @option global_account_data [String] :country_code *required*
      # @option global_account_data [String] :required_features *required*
      # @option global_account_data [String] :request_id *required*
      # @return [AirwallexRuby::GlobalAccount]
      def self.create(global_account_data, options = {})
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, global_account_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Update a global account using the API.
      #
      # @param [String] global_account_id *required*
      # @param [Hash] global_account_data *required*
      # @return [AirwallexRuby::GlobalAccount]
      def self.update(global_account_id, global_account_data, options = {})
        temp_account = new(id: global_account_id)
        temp_account.update(global_account_data, options)
      end

      # Fetches all global accounts using the API.
      #
      # @param [Hash] options
      # @options [String] :country_code - Country of the global account (2-letter ISO 3166-2 country code)
      # @options [String] :from_created_at - The start date of created_at in ISO8601 format (inclusive)
      # @options [String] :nick_name - Nickname of the global account
      # @options [String] :required_features.currency - Currency that was specified during Global Account creation
      # @options [String] :status - Status of the account
      # @options [String] :supported_features.currency - Currency that is supported by the Global Account
      # @options [String] :to_created_at - The end date of created_at in ISO8601 format (inclusive)
      # @options [String] :page - A bookmark for use in pagination to retrieve either the next page or the previous page of results. You can fetch the value for this identifier from the response of the previous API call. To retrieve the next page of results, pass the value of page_after (if not null) from the response to a subsequent call. To retrieve the previous page of results, pass the value of page_before (if not null) from the response to a subsequent call.
      # @options [Integer] :page_size - Number of results per page. Default value is 100.
      # @return [Array<AirwallexRuby::GlobalAccount>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a global account using the API.
      #
      # @param [String] global_account_id the Global Account Id
      # @return [AirwallexRuby::GlobalAccount]
      def self.find(global_account_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{global_account_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Close a global account using the API.
      #
      # @param [String] global_account_id the Global Account Id
      # @return [AirwallexRuby::GlobalAccount]
      def self.close(global_account_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{global_account_id}/close" 
        end

        response = post(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Generate a statement letter for a global account using the API.
      #
      # @param [String] global_account_id the Global Account Id
      # @param [Hash] global_account_data the Global Account Data
      # @return [HTTP::Response]
      def self.generate_statement_letter(global_account_id, global_account_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{global_account_id}/generate_statement_letter" 
        end

        post(request_url, global_account_data, options.merge(raw_response: true, file: true))
      end

      # Fetch transactions for a global account using the API.
      #
      # @param [String] global_account_id the Global Account Id
      # @param [Hash] options
      # @options [String] :from_created_at - The start date of created_at in ISO8601 format (inclusive)
      # @options [String] :to_created_at - The end date of created_at in ISO8601 format (inclusive)
      # @options [Integer] :page_num - Page number, starts from 0
      # @options [Integer] :page_size - Number of results per page. Default value is 100.
      # @return [Array<Hash>]
      def self.transactions(global_account_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{global_account_id}/transactions" 
        end

        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetch mandates for a global account using the API.
      #
      # @param [String] global_account_id the Global Account Id
      # @param [Hash] options
      # @options [String] :from_created_at - The start time of created_at (inclusive)
      # @options [String] :status - Status of the mandate, possible value should be ACTIVE, CANCELLED
      # @options [String] :to_created_at - The end time of created_at (inclusive)
      # @options [Integer] :page_num - Page number starts from 0, default value is 0
      # @options [Integer] :page_size - Number of results per page, default value is 50
      # @return [Array<Hash>]
      def self.mandates(global_account_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{global_account_id}/mandates" 
        end

        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| item.deep_symbolize_keys }
      end

      # Fetch a mandate for a global account using the API.
      #
      # @param [String] global_account_id the Global Account Id
      # @param [String] mandate_id the Mandate Id
      # @return [Hash]
      def self.mandate(global_account_id, mandate_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{global_account_id}/mandates/#{mandate_id}" 
        end

        response = get(request_url, {}, options)
        JSON.parse(response.body).deep_symbolize_keys
      end

      # Cancel a mandate for a global account using the API.
      #
      # @param [String] global_account_id the Global Account Id
      # @return [Boolean]
      def self.cancel_mandate(global_account_id, mandate_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{global_account_id}/mandates/#{mandate_id}/cancel" 
        end

        response = post(request_url, {}, options.merge(raw_response: true))
        response.status.to_i == 200
      end

      # Update a GlobalAccount using the API.
      #
      # @param [Hash] global_account_data
      # @return [AirwallexRuby::GlobalAccount]
      def update(global_account_data, options = {})
        attributes = self.class.attributes - [:id]
        request_body = self.class.parse_body_for_request(attributes, global_account_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{id}/update" }
        response = self.class.post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        self.class.new(response_body)
      end
      # End of Customer class
    end
  end
end
