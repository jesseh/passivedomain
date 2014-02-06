require_dependency Rails.root.join('lib', 'passive_domain').to_s

module PassiveDomain
  class UndefinedInterface
    def sends;       nil; end
    def responds_to; nil; end
    def responder;   nil; end
  end

  class Interface
    extend ClassMethods

    IGNORED_METHODS = [:inputs, :input_targets, :initialize_attrs,
                       :assert_frozen, :initialized_values]

    def self.for_class(cls)
      return UndefinedInterface.new unless cls.respond_to? :inputs
      self.new(cls)
    end

    # Instantiate with a class
    value_object_initializer do
      value(:name).must_be(only.string_symbol_or_nil).freeze_it
      value(:inputs => :sends).must_be(only.instance_array(Input)).freeze_it
      value(:instance_methods => :responds_to).
        send_args(true).must_be(only.instance_array(Symbol)).freeze_it
    end

    attr_reader :name

    def responds_to
      (@responds_to - Object.instance_methods - IGNORED_METHODS).freeze
    end

    def sends
      collector = {}
      inputs = @sends.dup
      while input = inputs.shift
        if input.source.respond_to? :inputs
          inputs.concat input.source.inputs
        else
          collect_input(collector, input)
        end
      end
      collector.freeze
    end

    def responder(params={})
      return nil if sends.keys[0].nil? and sends[nil].nil?
      return sends[nil].standin_value if sends.keys[0].nil? 

      params = default_responder_params.update params
      instance = responder_class.new
      params.each { |method, value| instance.send("#{method}=", value.freeze) unless method.nil? }
      instance
    end

    private

    def responder_class
      method_symbols = sends.keys.map{ |s| ":#{s}" }.join', '
      responder_class = Class.new 
      to_eval = "attr_accessor #{method_symbols}"
      responder_class.class_eval to_eval
      responder_class
    end

    def default_responder_params
      sends.inject({}) do |collector, (message, only)| 
        collector[message] = only.nil? ? nil : only.standin_value
        collector
      end
    end

    def assert_only_same(collector, input)
      if collector[input.source] != input.only
        raise TypeError, "Only objects must be the same for multiple uses of '#{input.source}'."
      end
    end

    def collect_input collector, input
      if collector[input.source] 
        assert_only_same collector, input
      else
        collector[input.source] = input.only
      end
      collector
    end

  end
end
