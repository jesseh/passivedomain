# Enable an object to be initialized with attributes that are requested from
# another object. Listing the initialized attributes helps to to create clean,
# non-leaking APIs between objects.
#
# The attributes are set to be only privately readable by default to limit what
# the initialized object reveal. Only the readers is set, rather than
# attr_accessor to encourage the state to be immutable where possible.
#
# The values used during initialization are stored in @@initializer_values,
# which is protected. It's no private because it is useful for testing
# equality.

require_dependency Rails.root.join('lib', 'specification', 'interface').to_s
require_relative "builder"
require_relative "instance_methods"

module PassiveDomain
  module ClassMethods

    # Method similar to attr_accessor that defines the initializer for a class and sets up private attr_readers
    def value_object_initializer(*inputs,&block)
      # Temporary scaffolding during refactoring to Specification
      if (inputs[0]).kind_of?(Specification::Interface)
        interface = inputs[0]
      else
        builder = Builder.new(*inputs,&block)
        built_inputs = builder.inputs
        input_targets = builder.input_targets
        interface = nil
      end

      # Temporary scaffolding during refactoring to Specificatin
      # Not all these class vars are needed
      if (inputs[0]).kind_of?(Specification::Interface)
        self.class_variable_set :@@interface, interface
      else
        self.class_variable_set :@@inputs, built_inputs
        self.class_variable_set :@@input_targets, input_targets
      end


      attr_reader(*input_targets)
      private(*input_targets)

      include InstanceMethods
    end

    def interface
      self.class_variable_get(:@@interface)
    end

    def inputs
      self.class_variable_get(:@@inputs)
    end

    def input_targets
      self.class_variable_get(:@@input_targets)
    end

    def stand_in
      #TODO simplify after refactor to specification
      if self.interface
        responder = self.interface.responder
      else
        responder = Interface.new(self).responder
      end
      self.new(responder)
    end

  end
end
