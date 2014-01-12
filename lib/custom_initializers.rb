# Enable an object to be initialized with attributes that are requested from
# another object. Listing the initialized attributes helps to to create clean,
# non-leaking APIs between objects.
#
# The attributes are set to be only privately readable by default to limit what
# the initialized object reveal. Only the readers is set, rather than
# attr_accessor to encourage the state to be immutable where possible.
#
# The values used during initialization are stored in @initializer_values,
# which is protected. It's no private because it is useful for testing
# equality.

module CustomInitializers

  # Method similar to attr_accessor that defines the initializer for a class and sets up private attr_readers
  def value_object_initializer(*attribute_targets)

    # Call initialize_attrs directly if overriding initialize.
    define_method(:initialize) do |data_obj|
      initialize_attrs(data_obj)
    end


    attr_targets = parse_targets(attribute_targets).freeze
    attrs = attr_targets.values.freeze

    define_method(:initialize_attrs) do |data_obj|
      attr_targets.each do |source, target_attr|
        value = source.respond_to?(:new) ? source.new(data_obj) : data_obj.send(source)
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

    attrs_to_protect = [:initialized_attrs, :initialized_values]
    attr_reader *attrs_to_protect
    protected *attrs_to_protect

    attr_reader *attrs
    private *attrs

    define_method(:inspect) do 
      self.class.to_s + ': ' + initialized_attrs.zip(initialized_values).map { |a, v| "#{a}=#{v}" }.join(", ")
    end

    define_method(:to_s) do
      inspect
    end

    define_method(:initialized_values) do
      initialized_attrs.map{ |a| "'#{self.send(a)}'" }
    end

    define_method(:==) do |other|
      other.instance_of?(self.class) && initialized_values == other.initialized_values
    end

    define_method(:eql?) do |other|
      self.send(:==, other)
    end

    define_method(:hash) do
      self.class.hash ^ initialized_values.hash
    end
  end


  private

  def parse_targets(targets)
    attrs = {}
    targets.each do |target_or_hash|
      if target_or_hash.respond_to? :each
        target_or_hash.each do |target, source_message|
          attrs[target] = underscore(source_message.to_s).to_sym
        end
      else
        attrs[target_or_hash] = underscore(target_or_hash.to_s).to_sym
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

  def assert_immutable(target, value)
  end

end

