module BluesnapRuby
  class Error < StandardError
    attr_reader :error
    attr_reader :response_body

    def initialize(options = {})
      @error = options[:error]
      @response_body = options[:response_body]
      super(options.to_json)
    end

    def self.create description, response_body = nil
      attrs = { error: description, response_body: response_body }
      new(attrs)
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
  end
end
