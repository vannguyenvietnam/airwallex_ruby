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
      SecureRandom.urlsafe_base64(32)
    end

    # Generate code_challenge
    def generate_code_challenge
      code_verifier = generate_code_verifier
      digest = OpenSSL::Digest::SHA256.digest(code_verifier)
      base64 = [digest].pack('m0')
      base64.tr('+/', '-_').gsub('=', '')
    end
  end
  # End of Helpers module
end
