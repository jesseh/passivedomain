module Specification
  class Interface

    def initialize(signatures)
      build_index signatures
    end

    def method_symbols
      @index.keys
    end

    def valid_method_name?(method_symbol)
      index.keys.include?(method_symbol)
    end

    def valid_response?(method_symbol, response)
      valid_method_name?(method_symbol) &&
        signature_for(method_symbol).valid_response?(response)
    end

    def valid_send?(target, method_symbol, arguments=[])
      return false unless valid_method_name?(method_symbol)
      return false unless target.respond_to?(method_symbol)

      signature = signature_for(method_symbol)

      return false unless signature.valid_arguments?(arguments)

      if signature.idempotent?
        response = target.send(method_symbol, *arguments)
        return false unless signature.valid_response?(response)
      end

      true
    end

    def responder(override_params={})
      Class.new.tap do |instance|
        responder_params(override_params).each do |method_symbol, value| 
          instance.define_singleton_method(method_symbol) { |*args| value }
        end
      end
    end

    def conforms?(subject)
      method_symbols.map do |method_symbol|
        valid_send?(subject, method_symbol, signature_for(method_symbol).standin_arguments)
      end.all?
    end

    private

    attr_reader :index

    def signature_for(method_symbol)
      index.fetch(method_symbol)
    end

    def build_index(signatures)
      @index ||= signatures.inject({}) do |collector, signature| 
        raise(ArgumentError, "Duplicate signature for method '#{signature.method_symbol}'") if collector.key?(signature.method_symbol) 
        collector[signature.method_symbol] = signature
        collector
      end
    end

    def responder_params(overrides)
      default_responder_params.tap do |params|
        overrides.each do |k, v|
          raise(KeyError, "Parameter '#{k}' has no message in the interface.") unless valid_method_name?(k)
          params[k] = v
        end
      end
    end

    def default_responder_params
      index.inject({}) do |collector, (method_symbol, signature)| 
        collector[method_symbol] = signature.sample_response
        collector
      end
    end
  end
end
