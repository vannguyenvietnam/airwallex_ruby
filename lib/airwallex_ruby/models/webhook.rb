module AirwallexRuby
  module Model
    class Webhook < Base
      attr_accessor :id, :created_at, :events, :request_id, :secret, :updated_at, :url, :version

      ENDPOINT = '/webhooks'

      # Uses the API to create a webhook.
      #
      # @param [Hash] webhook_data
      # @option webhook_data [Array] :events *required*
      # @option webhook_data [Array] :url *required*
      # @option webhook_data [Array] :version *required*
      # @option webhook_data [String] :request_id *required*
      # @return [AirwallexRuby::Webhook]
      def self.create(webhook_data, options = {})
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, webhook_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Update a webhook using the API.
      #
      # @param [String] webhook_id *required*
      # @param [Hash] webhook_data *required*
      # @return [AirwallexRuby::Webhook]
      def self.update(webhook_id, webhook_data, options = {})
        temp_account = new(id: webhook_id)
        temp_account.update(webhook_data, options)
      end

      # Fetches all webhooks using the API.
      #
      # @param [Hash] options
      # @options [Integer] :page_num - Page number starting from 0. Defaults to 0.
      # @options [Integer] :page_size - Number of Webhooks per page. Defaults to 20.
      # @return [Array<AirwallexRuby::Webhook>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a webhook using the API.
      #
      # @param [String] webhook_id the Webhook Id
      # @return [AirwallexRuby::Webhook]
      def self.find(webhook_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{webhook_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Delete a webhook using the API.
      #
      # @param [String] webhook_id the Webhook Id
      # @return [TrueClass, FalseClass]
      def self.delete(webhook_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{webhook_id}/delete" 
        end

        response = post(request_url, {}, options.merge(raw_response: true))
        response.code.to_s == '200'
      end

      # Connect a webhook using the API.
      #
      # @param [String] webhook_id the Webhook Id
      # @return [TrueClass, FalseClass]
      def self.connect(webhook_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{webhook_id}/connect" 
        end

        response = post(request_url, {}, options.merge(raw_response: true))
        response.code.to_s == '200'
      end

      # Disconnect a webhook using the API.
      #
      # @param [String] webhook_id the Webhook Id
      # @return [TrueClass, FalseClass]
      def self.disconnect(webhook_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{webhook_id}/disconnect" 
        end

        response = post(request_url, {}, options.merge(raw_response: true))
        response.code.to_s == '200'
      end

      # Update a Webhook using the API.
      #
      # @param [Hash] webhook_data
      # @return [AirwallexRuby::Webhook]
      def update(webhook_data, options = {})
        attributes = self.class.attributes - [:id]
        request_body = self.class.parse_body_for_request(attributes, webhook_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{id}/update" }
        response = self.class.post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        self.class.new(response_body)
      end
      # End of Customer class
    end
  end
end
