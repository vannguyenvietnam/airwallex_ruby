module AirwallexRuby
  module Model
    class ReferenceData < Base
      attr_accessor :id, :card_brand, :card_type, :commercial_card, :issuer_country_code, :issuer_name, 
                    :product_code, :product_description, :product_subtype_code, :product_subtype_description

      ENDPOINT = '/pa/reference/bin/lookup'

      # Fetches a reference data using the API.
      #
      # @param [String] pan_number the PAN Number
      # @return [AirwallexRuby::ReferenceData]
      def self.find(pan_number, options = {})
        request_url = URI.parse(AirwallexRuby.api_url).tap { |uri| uri.path += "#{ENDPOINT}" }
        options[:header] = { "x-pan" => pan_number }
        response = get(request_url, {}, options)
        response_body = JSON.parse(response.body)
        response_body.map { |item| new(item.deep_symbolize_keys) }
      end
      # End of ReferenceData class
    end
  end
end
