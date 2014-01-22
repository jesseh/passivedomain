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

require_relative "only"
require_relative "ask"
require_relative "builder"
require_relative "instance_methods"

module PassiveDomain
  module ClassMethods

    def ask(source, only=only.anything, &block)
      Ask.new(source, only, block)
    end

    def only(*args)
      Only.new
    end

    attr_reader :attribute_targets, :attribute_values

    # Method similar to attr_accessor that defines the initializer for a class and sets up private attr_readers
    def value_object_initializer(*attribute_targets)
      builder      = Builder.new(*attribute_targets)
      @attribute_targets = builder.attribute_targets
      @attribute_values  = builder.attribute_values

      attr_reader(*@attribute_values)
      private(*@attribute_values)

      include InstanceMethods
    end

  end
end
