module AirwallexRuby
  class Error < StandardError
    attr_reader :error
    attr_reader :response_body

    def initialize(message, options = {})
      @error = message
      @response_body = options[:response_body]
      super(message)
    end

    def self.create description, response_body = nil
      request_options = { response_body: response_body }
      new(description, request_options)
    end

    def message
      @error.to_s
    end

    def full_message
      @error.to_s + ' ' + @response_body.to_s
    end

    def response_body
      @response_body
    end

    class InvalidResponse  < Error; end
  end
end
