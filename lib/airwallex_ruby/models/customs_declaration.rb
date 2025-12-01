module AirwallexRuby
  module Model
    class CustomsDeclaration < Base
      attr_accessor :id, :awx_request_id, :created_at, :customs_details, :customs_status_message, 
                    :payment_method_type, :provider_transaction_id, :request_id, :shopper_identity_check_result, 
                    :status, :sub_order, :updated_at, :verification_department_code, 
                    :verification_department_transaction_id

      ENDPOINT = '/pa/customs_declarations'

      # Uses the API to create a customs declaration.
      #
      # @param [Hash] customs_declaration_data
      # @option customs_declaration_data [String] :customs_details *required*
      # @option customs_declaration_data [String] :payment_intent_id *required*
      # @option customs_declaration_data [String] :request_id *required*
      # @return [AirwallexRuby::CustomsDeclaration]
      def self.create(customs_declaration_data, options = {})
        attributes = self.attributes - [:id] # fix attributes allowed by POST API
        request_body = parse_body_for_request(attributes, customs_declaration_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/create" }
        response = post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Update a customs declaration using the API.
      #
      # @param [String] customs_declaration_id *required*
      # @param [Hash] customs_declaration_data *required*
      # @return [AirwallexRuby::CustomsDeclaration]
      def self.update(customs_declaration_id, customs_declaration_data, options = {})
        temp_account = new(id: customs_declaration_id)
        temp_account.update(customs_declaration_data, options)
      end

      # Fetches a customs declaration using the API.
      #
      # @param [String] customs_declaration_id the Customs Declaration Id
      # @return [AirwallexRuby::CustomsDeclaration]
      def self.find(customs_declaration_id, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{customs_declaration_id}" }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Redeclare a customs declaration using the API.
      #
      # @param [String] customs_declaration_id the Customs Declaration Id
      # @return [AirwallexRuby::CustomsDeclaration]
      def self.redeclare(customs_declaration_id, redeclare_data, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap do |uri| 
          uri.path += "#{ENDPOINT}/#{customs_declaration_id}/redeclare" 
        end

        response = post(request_url, redeclare_data, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        new(response_body)
      end

      # Update a customs declaration using the API.
      #
      # @param [Hash] customs_declaration_data
      # @return [AirwallexRuby::CustomsDeclaration]
      def update(customs_declaration_data, options = {})
        attributes = self.class.attributes - [:id]
        request_body = self.class.parse_body_for_request(attributes, customs_declaration_data)
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}/#{id}/update" }
        response = self.class.post(request_url, request_body, options)
        response_body = JSON.parse(response.body).deep_symbolize_keys
        self.class.new(response_body)
      end
      # End of Customer class
    end
  end
end
