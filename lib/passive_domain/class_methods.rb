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
    # This is a hash-like object where the values are weak references that may be collected
    # by the garbage collector. See https://github.com/bdurand/ref/blob/master/lib/ref/soft_value_map.rb
    @@cache = Ref::SoftValueMap.new
    @@hits = 0
    @@misses = 0

    #TODO - catch the weakref kernel error if garbage collected before strong reference created.
    #TODO - handle block
    def cache_get(target_class, *args)
      key = args.dup << target_class
      value_wrapper = @@cache[key]
      if value_wrapper.nil?
        #@@misses += 1
        #puts "miss (#{@@hits}, #{@@misses}, #{(100.0 * @@hits / (@@hits +  @@misses)).round(0)}%)"
        return nil
      end
      #@@hits += 1
      #puts "hit (#{@@hits}, #{@@misses}, #{(100.0 * @@hits / (@@hits +  @@misses)).round(0)}%)"
      value_wrapper[0]
    end

    def cache_store(instance, *args)
      key = args.dup << instance.class
      # Array wrapper needed because instance is (should be) frozen.
      value_wrapper = [instance]
      @@cache[key] = value_wrapper
    end

    def ask(source, only=only.anything, &block)
      Ask.new(source, only, block)
    end

    def only(*args)
      Only.new
    end

    def nested_interface(interface)
      interface.find { |source| source.respond_to?(:interface) }
    end
    private :nested_interface

    def interface
      begin
        self.new(PassiveDomain::COLLECT_INTERFACE)
      rescue PassiveDomain::InterfaceCollection => e
        result = e.attr_targets.keys
      end
      while source = nested_interface(result) do
        result.delete(source)
        result.concat(source.interface)
      end
      result
    end

    # Method similar to attr_accessor that defines the initializer for a class and sets up private attr_readers
    def value_object_initializer(*attribute_targets)

      # When overriding initialize be sure to call initialize_attrs directly
      define_method(:initialize) do |data_obj|
        initialize_attrs(data_obj)
      end

      attr_targets = parse_targets(attribute_targets).freeze
      attrs = attr_targets.values.freeze

      define_method(:initialize_attrs) do |data_obj|
        # Query the interface - this is exceptional behavior
        if data_obj == PassiveDomain::COLLECT_INTERFACE
          raise PassiveDomain::InterfaceCollection.new(attr_targets)
        end

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
