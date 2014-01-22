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
require_relative "instance_methods"

module PassiveDomain
  module ClassMethods

    def ask(source, only=only.anything, &block)
      Ask.new(source, only, block)
    end

    def only(*args)
      Only.new
    end

    # Method similar to attr_accessor that defines the initializer for a class and sets up private attr_readers
    def value_object_initializer(*attribute_targets)
      attr_targets = parse_targets(attribute_targets).freeze
      attrs = attr_targets.values.freeze

      define_method(:initialize_attrs) do |data_obj|
        attr_targets.each do |source, target_attr|
          value = begin
            if source.instance_of?(Ask)
              source.value(data_obj)
            elsif source.respond_to?(:new)
              source.new(data_obj)
            else
              data_obj.send(source)
            end
          end
          unless value.frozen? ||
                 value.nil?    ||
                 value.instance_of?(TrueClass) ||
                 value.instance_of?(FalseClass)
            raise TypeError, "#{self.class} can only be instantiated with frozen data. #{target_attr} has non-frozen value: #{value.inspect}"
          end
          instance_variable_set("@#{target_attr}", value)
        end
        instance_variable_set(:@initialized_attrs, attrs)
        freeze
      end

      attr_reader(*attrs)
      private(*attrs)

      include InstanceMethods
    end


    private

    def parse_targets(targets)
      attrs = {}
      targets.each do |target_or_hash|
        if target_or_hash.respond_to? :each
          target_or_hash.each do |source_message, target|
            attrs[source_message] = underscore(target.to_s).to_sym
          end
        else
          source = target_or_hash
          target = source.instance_of?(Ask) ? source.source : source

          attrs[source] = underscore(target.to_s).to_sym
        end
      end
      attrs
    end

    # method from Rails ActiveSupport.
    def underscore(str)
      str.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end
  end
end
