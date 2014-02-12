module Specification
  class Interface
    attr_reader :messages

    def initialize(messages)
      @messages = messages
    end

    def valid_response?(message, response)
      valid_message?(message) && messages[message].valid?(response)
    end

    def valid_message?(message)
      messages.keys.include?(message)
    end

    def responder(override_params={})
      Class.new.tap do |instance|
        responder_params(override_params).each do |method, value| 
          instance.define_singleton_method(method) { value }
        end
      end
    end


    private

    def responder_params(overrides)
      default_responder_params.tap do |params|
        overrides.each do |k, v|
          raise(NameError, "Parameter '#{k}' has no message in the interface.") unless valid_message?(k)
          params[k] = v
        end
      end
    end

    def default_responder_params
      messages.inject({}) do |collector, (message, only)| 
        collector[message] = only.nil? ? nil : only.standin_value
        collector
      end
    end
  end
end
