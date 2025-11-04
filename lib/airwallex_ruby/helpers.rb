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
    def generate_code_verifier(length = 64)
      # SecureRandom.urlsafe_base64(32)
      raise ArgumentError, "Length must be between 43 and 128" unless (43..128).cover?(length)

      verifier = Array.new(length) { UNRESERVED_CHARS[SecureRandom.random_number(UNRESERVED_CHARS.size)] }.join
      verifier
    end

    # Generate code_challenge
    # def generate_code_challenge
    #   code_verifier = generate_code_verifier
    #   digest = OpenSSL::Digest::SHA256.digest(code_verifier)
    #   base64 = [digest].pack('m0')
    #   base64.tr('+/', '-_').gsub('=', '')
    # end

    def generate_code_challenge(length = 64)
      verifier = generate_code_verifier(length)
      challenge = Base64.urlsafe_encode64(Digest::SHA256.digest(verifier)).delete('=')
      # { code_verifier: verifier, code_challenge: challenge, method: 'S256' }
      challenge
    end
  end
  # End of Helpers module
end
