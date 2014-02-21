module PassiveDomain
  module InstanceMethods

    # When overriding initialize be sure to call initialize_attrs directly
    def initialize(data_obj)
      initialize_attrs(data_obj)
    end

    def inspect
      self.class.to_s + ': ' + input_targets.zip(initialized_values).map { |a, v| "#{a}='#{v}'" }.join(", ")
    end

    def to_s
      inspect
    end

    def ==(other)
      other.instance_of?(self.class) && initialized_values == other.initialized_values
    end

    def eql?(other)
      self.send(:==, other)
    end

    def hash
      self.class.hash ^ initialized_values.hash
    end

    protected

    def interface
      self.class.interface
    end

    def inputs
      self.class.inputs
    end

    def input_targets
      self.class.input_targets
    end

    def initialize_attrs(data_obj)
      data_obj = OpenStruct.new(data_obj) if data_obj.is_a? Hash
      #TODO remove options after refactor to Specification
      if interface
        interface.method_symbols.each do |method_symbol|
          value = data_obj.public_send(method_symbol, *@args)

          # TODO: Get the asserts working again.
          #assert_valid raw
          #assert_frozen value, input.target
          instance_variable_set("@#{method_symbol}", value)
        end
      else
        inputs.each do |input|
          value = input.value data_obj
          assert_frozen value, input.target
          instance_variable_set("@#{input.target}", value)
        end
      end
      freeze
    end

    def assert_frozen(value, target)
      unless value.frozen? ||
             value.nil?    ||
             value.instance_of?(TrueClass) ||
             value.instance_of?(FalseClass)
        raise TypeError, "#{self.class} can only be instantiated with frozen data. '#{target}' has non-frozen value: #{value.inspect}"
      end
    end

    def initialized_values
      # TODO: Clean up after refactor to Specification
      if interface
        targets = interface.method_symbols
      else
        targets = input_targets
      end
      targets.map{|a| self.send(a.to_sym) }
    end

    private


  end
end
