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

require_relative "builder"
require_relative "instance_methods"

module PassiveDomain
  module ClassMethods

    attr_reader :inputs, :input_targets

    # Method similar to attr_accessor that defines the initializer for a class and sets up private attr_readers
    def value_object_initializer(*inputs,&block)
      builder        = Builder.new(*inputs,&block)
      input_targets = builder.input_targets

      self.class_variable_set :@@inputs, builder.inputs
      self.class_variable_set :@@input_targets, builder.input_targets


      attr_reader(*input_targets)
      private(*input_targets)

      include InstanceMethods
    end

    def inputs
      self.class_variable_get(:@@inputs)
    end

    def input_targets
      self.class_variable_get(:@@input_targets)
    end

  end
end
