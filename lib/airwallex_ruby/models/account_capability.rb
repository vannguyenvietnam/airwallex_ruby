module AirwallexRuby
  module Model
    class AccountCapability < Base
      attr_accessor :id, :comment, :details, :entity_type, :status, :updated_at, :requested_limit, :mandate_type,
                    :limit, :effective_at, :currency, :availables

      ENDPOINT = '/account_capabilities'

      # Fetches an account capability using the API.
      #
      # @param [String] account_capability_id the Account Capability Id
      # @return [AirwallexRuby::AccountCapability]
      def self.find account_capability_id, options = {}
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{account_capability_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Enables an account capability using the API.
      #
      # @param [String] account_capability_id the Account Capability Id
      # @return [AirwallexRuby::AccountCapability]
      def self.enable account_capability_id, options = {}
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{account_capability_id}/enable" 
        end

        request_body = {
          id: account_capability_id,
          enroll_sme_program: options[:enroll_sme_program]
        }

        response = post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Fetches all funding limits of your Accounts using the API.
      #
      # @param [Hash] options
      # @options [String] :ccy - Specify the currency the limit will be displayed in. A single limit is applied for the entire customer, regardless of the display currency.
      # @options [String] :effective_at - The timestamp at which the customer's funding limit becomes effective.
      # @options [String] :mandate_type - The settlement method or clearing system.
      # @options [Integer] :page_num - Positive integer. Page number
      # @options [Integer] :page_size - Positive integer. Page size
      # @return [Array<AirwallexRuby::AccountCapability>]
      def self.funding_limits options = {}
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{account_capability_id}/funding_limits" 
        end
        
        params_text = options.map { |k, v| "#{k}=#{ERB::Util.url_encode(v.to_s)}" }.join("\&")
        request_url.query = params_text
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end
    end
  end
end
