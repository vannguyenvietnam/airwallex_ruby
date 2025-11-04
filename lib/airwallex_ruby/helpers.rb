module AirwallexRuby
  # RefinedString module
  module RefinedString
    refine String do
      def underscore
        self.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
      end
    end
  end
  # End of RefinedString module

  # Helpers module
  module Helpers
    using RefinedString

    UNRESERVED_CHARS = [('A'..'Z'), ('a'..'z'), ('0'..'9'), ['-', '.', '_', '~']].map(&:to_a).flatten.freeze

    def model(model_name)
      method_name = model_name.to_s.underscore
      variable_name = "@#{method_name}_model".to_sym

      unless instance_variable_defined?(variable_name)
        instance_variable_set(variable_name, AirwallexRuby::Model.const_get("#{model_name}".to_sym).new(self, model_name.to_s))

        self.define_singleton_method(method_name.to_sym) do
          instance_variable_get(variable_name)
        end
      end

      instance_variable_get(variable_name)
    end

    # Generate code_verifier
    def generate_code_verifier
      # generate random length for code_verifier which should be between 43 and 128
      length = SecureRandom.random_number(129 - 43) + 43
      Array.new(length) { UNRESERVED_CHARS[SecureRandom.random_number(UNRESERVED_CHARS.size)] }.join
    end

    def generate_code_challenge
      code_verifier = generate_code_verifier
      Base64.urlsafe_encode64(Digest::SHA256.digest(code_verifier)).delete('=')
    end
  end
  # End of Helpers module
end
