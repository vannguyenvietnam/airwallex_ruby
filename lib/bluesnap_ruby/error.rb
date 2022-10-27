module BluesnapRuby
  class Error < StandardError
    def self.create description, messages = nil
      if messages.is_a?(Array)
        temp_messages = messages.map do |item| 
          result = item.to_s
          
          if item.is_a?(Hash)
            result = "(#{item['errorName'].to_s.downcase} #{item['code']} - #{item['description']})"
          end
          
          result
        end

        description = description + ' ' + temp_messages.join(' & ')
      elsif messages.is_a?(Hash)
        description = { description: description, messages: messages }
      end
      
      new(description)
    end
  end
end
