module AirwallexRuby
  module Model
    class Transfer < Base
      attr_accessor :id, :amount_beneficiary_receives, :amount_payer_pays, :application_fee_options,
                    :application_fees, :batch_transfer_id, :beneficiary, :beneficiary_id, :conversion,
                    :created_at, :dispatch_date, :dispatch_info, :failure_reason, :failure_type, :fee_amount,
                    :fee_currency, :fee_paid_by, :funding, :lock_rate_on_create, :metadata, :payer, :payer_id,
                    :prepayment, :reason, :reference, :remarks, :request_id, :short_reference_id, :source_amount,
                    :source_currency, :status, :swift_charge_option, :transfer_amount, :transfer_currency,
                    :transfer_date, :transfer_method, :updated_at

      ENDPOINT = '/transfers'

      # Uses the API to create a transfer.
      #
      # @param [Hash] transfer_data
      # @option transfer_data [String] :reason *required*
      # @option transfer_data [String] :reference *required*
      # @option transfer_data [String] :request_id *required*
      # @option transfer_data [String] :transfer_currency *required*
      # @return [AirwallexRuby::Transfer]
      def self.create(transfer_data, options = {})
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, transfer_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Fetches all transfers using the API.
      #
      # @param [Hash] options
      # @options [String] :batch_transfer_id - Batch transfer ID
      # @options [String] :beneficiary_id - Beneficiary ID
      # @options [String] :from_created_at - The start date of created_at in ISO8601 format (inclusive)
      # @options [String] :request_id - Transfer request_id.
      # @options [String] :short_reference_id - Transfer short_reference_id.
      # @options [String] :status - Status of the transfer
      # @options [String] :to_created_at - The end date of created_at in ISO8601 format (inclusive).
      # @options [String] :transfer_currency - Transfer currency.
      # @options [String] :page - A bookmark for use in pagination to retrieve either the next page or the previous page of results. You can fetch the value for this identifier from the response of the previous API call. To retrieve the next page of results, pass the value of page_after (if not null) from the response to a subsequent call. To retrieve the previous page of results, pass the value of page_before (if not null) from the response to a subsequent call. The 30-day limit will be removed if page is present in the request. Passing page=0 on the very first page will override the 30 days default for null date ranges, enabling a complete search of the transfers.
      # @options [Integer] :page_size - Number of results per page, defaultValue 2000
      # @return [Array<AirwallexRuby::Transfer>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a transfer using the API.
      #
      # @param [String] transfer_id the Transfer Id
      # @return [AirwallexRuby::Transfer]
      def self.find(transfer_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{transfer_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Cancel a transfer using the API.
      #
      # @param [String] transfer_id the Transfer Id
      # @return [TrueClass|FalseClass]
      def self.cancel(transfer_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{transfer_id}/cancel" 
        end

        response = post(request_url, {}, options.merge(raw_response: true))
        response.code.to_s == '200'
      end

      # Confirm funding for a transfer using the API.
      #
      # @param [String] transfer_id the Transfer Id
      # @return [AirwallexRuby::Transfer]
      def self.confirm_funding(transfer_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{transfer_id}/confirm_funding" 
        end

        response = post(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Validate a transfer using the API.
      #
      # @param [Hash] transfer_data the Transfer data
      # @param transfer_data [String] :reason *required*
      # @param transfer_data [String] :reference *required*
      # @param transfer_data [String] :request_id *required*
      # @param transfer_data [String] :transfer_currency *required*
      # @return [AirwallexRuby::Transfer]
      def self.validate(transfer_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/validate" 
        end

        response = post(request_url, transfer_data, options.merge(raw_response: true))
        response.code.to_s == '200'
      end

      # Begin::Simulation APIs
      # Transition the status a transfer using the API.
      #
      # @param [String] transfer_id the Transfer data
      # @param [Hash] simulation_data the Transfer data
      # @return [AirwallexRuby::Transfer]
      def self.transition(transfer_id, simulation_data, options = {})
        request_url = URI.parse(AirwallexRuby.simulation_api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{transfer_id}/transition" 
        end

        response = post(request_url, simulation_data, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end
      # End::Simulation APIs
      # End of Transfer class
    end
  end
end
