module Specification
  class Interface

    def initialize(signatures)
      build_index signatures
    end

    def method_symbols
      @index.keys
    end

    def valid_response?(method_symbol, response)
      valid_method?(method_symbol) && index.fetch(method_symbol).valid_response?(response)
    end

    def valid_method?(method_symbol)
      index.keys.include?(method_symbol)
    end

    def responder(override_params={})
      Class.new.tap do |instance|
        responder_params(override_params).each do |method_symbol, value| 
          instance.define_singleton_method(method_symbol) { value }
        end
      end
    end


    private

    attr_reader :index

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
          raise(KeyError, "Parameter '#{k}' has no message in the interface.") unless valid_method?(k)
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
