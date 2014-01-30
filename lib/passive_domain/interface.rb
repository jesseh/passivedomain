require_dependency Rails.root.join('lib', 'passive_domain').to_s

module PassiveDomain
  class Interface
    extend ClassMethods

    IGNORED_METHODS = [:inputs, :input_targets, :initialize_attrs,
                       :assert_frozen, :initialized_values]

    # Instantiate with a class
    value_object_initializer do
      value(:inputs => :sends).
        must_be(only.instance_array(Input)).
        transform do |raw|
          raw.inject({}) do |collector, input| 
            if collector[input.source] 
              if collector[input.source] != input.only
                raise TypeError, "Only objects must be the same for multiple uses of '#{input.source}'."
              end
            else
              collector[input.source] = input.only
            end
            collector
          end.freeze
        end

      value(:instance_methods => :responds_to).
        send_args(true).
        must_be(only.instance_array(Symbol)).
        transform do |raw| 
          methods = (raw - Object.instance_methods - IGNORED_METHODS).freeze
          methods
        end

      value(:name).
        must_be(only.string_symbol_or_nil).
        transform { |raw| raw.freeze }

    end

    attr_reader :sends, :responds_to, :name

    def responder(params={})
      params = default_responder_params.update params
      instance = responder_class.new
      params.each { |method, value| instance.send("#{method}=", value) }
      instance
    end

    private

    def responder_class
      methods = sends.keys
      Struct.new(*methods)
    end

    def default_responder_params
      sends.inject({}) do |collector, (message, only)| 
        collector[message] = only.nil? ? nil : only.standin_value
        collector
      end
    end

  end
end
