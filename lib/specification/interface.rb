module Specification
  class Interface

    def initialize(signatures)
      build_index signatures
    end

    def valid_response?(method, response)
      valid_method?(method) && index.fetch(method).valid_response?(response)
    end

    def valid_method?(method)
      index.keys.include?(method)
    end

    def responder(override_params={})
      Class.new.tap do |instance|
        responder_params(override_params).each do |method, value| 
          instance.define_singleton_method(method) { value }
        end
      end
    end


    private

    attr_reader :index

    def build_index(signatures)
      @index ||= signatures.inject({}) do |collector, signature| 
        raise(ArgumentError, "Duplicate signature for method '#{signature.method}'") if collector.key?(signature.method) 
        collector[signature.method] = signature
        collector
      end
    end

    def responder_params(overrides)
      default_responder_params.tap do |params|
        overrides.each do |k, v|
          raise(NameError, "Parameter '#{k}' has no message in the interface.") unless valid_method?(k)
          params[k] = v
        end
      end
    end

    def default_responder_params
      index.inject({}) do |collector, (method, signature)| 
        collector[method] = signature.sample_response
        collector
      end
    end
  end
end
