module Specification
  class Interface
    attr_reader :messages

    def initialize(messages)
      @messages = messages
    end

    def valid_response?(message, response)
      return false unless messages.keys.include?(message)
      messages[message].valid? response
    end

    def responder(override_params={})
      params = default_responder_params
      param_keys = params.keys

      override_params.each do |k, v|
        raise(NameError, "Parameter '#{k}' has no message in the interface.") unless param_keys.include?(k)
        params[k] = v
      end
      instance = Class.new
      params.each do |method, value| 
        instance.define_singleton_method(method) { value }
      end
      instance
    end

    private

    def default_responder_params
      messages.inject({}) do |collector, (message, only)| 
        collector[message] = only.nil? ? nil : only.standin_value
        collector
      end
    end
  end
end
