module AirwallexRuby
  module Model
    class BatchTransfer < Base
      attr_accessor :id, :funding, :metadata, :name, :quote_summary, :remarks, :request_id, :short_reference_id,
                    :status, :total_item_count, :transfer_date, :updated_at, :valid_item_count

      ENDPOINT = '/batch_transfers'

      # Uses the API to create a batch transfer.
      #
      # @param [Hash] batch_transfer_data
      # @option batch_transfer_data [String] :request_id *required*
      # @return [AirwallexRuby::BatchTransfer]
      def self.create(batch_transfer_data, options = {})
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, batch_transfer_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Fetches all batch transfers using the API.
      #
      # @param [Hash] options
      # @options [String] :request_id - Batch transfer request_id.
      # @options [String] :short_reference_id - Batch transfer short_reference_id
      # @options [String] :status - The batch transfer status
      # @options [String] :page - A bookmark for use in pagination to retrieve either the next page or the previous page of results. You can fetch the value for this identifier from the response of the previous API call. To retrieve the next page of results, pass the value of page_after (if not null) from the response to a subsequent call. To retrieve the previous page of results, pass the value of page_before (if not null) from the response to a subsequent call.
      # @options [Integer] :page_size - Number of results per page, default and max value is 50
      # @return [Array<AirwallexRuby::BatchTransfer>]
      def self.all(options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += ENDPOINT }
        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| new(item.deep_symbolize_keys) }
      end

      # Fetches a batch transfer using the API.
      #
      # @param [String] batch_transfer_id the Batch Transfer Id
      # @return [AirwallexRuby::BatchTransfer]
      def self.find(batch_transfer_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{batch_transfer_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Delete a batch transfer using the API.
      #
      # @param [String] batch_transfer_id the Batch Transfer Id
      # @return [AirwallexRuby::BatchTransfer]
      def self.delete(batch_transfer_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{batch_transfer_id}/delete" 
        end

        response = post(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Quote a batch transfer using the API.
      #
      # @param [String] batch_transfer_id the Batch Transfer Id
      # @return [AirwallexRuby::BatchTransfer]
      def self.quote(batch_transfer_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{batch_transfer_id}/quote" 
        end

        response = post(request_url, {}, options)
        request_body = JSON.parse(response.body).deep_symbolize_keys
        new(request_body)
      end

      # Submit a batch transfer using the API.
      #
      # @param [String] batch_transfer_id the Batch Transfer Id
      # @return [AirwallexRuby::BatchTransfer]
      def self.submit(batch_transfer_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{batch_transfer_id}/submit" 
        end

        response = post(request_url, {}, options)
        request_body = JSON.parse(response.body).deep_symbolize_keys
        new(request_body)
      end

      # Fetch items of a batch transfer using the API.
      #
      # @param [String] batch_transfer_id the Batch Transfer Id
      # @param [Hash] options
      # @options [String] :page - A bookmark for use in pagination to retrieve either the next page or the previous page of results. You can fetch the value for this identifier from the response of the previous API call. To retrieve the next page of results, pass the value of page_after (if not null) from the response to a subsequent call. To retrieve the previous page of results, pass the value of page_before (if not null) from the response to a subsequent call.
      # @options [Integer] :page_size - Number of results per page, default and max value is 1000
      # @return [Array<Hash>]
      def self.items(batch_transfer_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{batch_transfer_id}/items" 
        end

        request_url.query = init_params_for_request(options)
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        return [] if response_body['items'].nil?

        response_body['items'].map { |item| item.deep_symbolize_keys }
      end

      # Add items to a batch transfer using the API.
      #
      # @param [String] batch_transfer_id the Batch Transfer Id
      # @param [Hash] items_data the Batch Transfer Data
      # @return [AirwallexRuby::BatchTransfer]
      def self.add_items(batch_transfer_id, items_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{batch_transfer_id}/add_items" 
        end

        response = post(request_url, items_data, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Delete items from a batch transfer using the API.
      #
      # @param [String] batch_transfer_id the Batch Transfer Id
      # @param [Hash] items_data the Batch Transfer Data
      # @return [AirwallexRuby::BatchTransfer]
      def self.delete_items(batch_transfer_id, items_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{batch_transfer_id}/delete_items" 
        end

        response = post(request_url, items_data, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end
      # End of BatchTransfer class
    end
  end
end
