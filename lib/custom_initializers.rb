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
  def private_attr_initializer(*attribute_targets)

    # Call initialize_private_attrs directly if overriding initialize.
    define_method(:initialize) do |data_obj|
      initialize_private_attrs(data_obj)
    end


    attrs = parse_targets(attribute_targets)

    define_method(:initialize_private_attrs) do |data_obj|
      attrs.each do |attr, source_message|
        instance_variable_set("@#{attr}", data_obj.send(source_message))
      end
    end

    @initialized_attrs = attrs.keys.freeze
    attr_reader :initialized_attrs
    protected :initialized_attrs

    @initialized_attrs.each do |attr|
      attr_reader attr
      private attr
    end

    define_method(:inspect) do 
      "#{self.class} " + initialized_attrs.map{ |a| "#{a}: '#{self.send(a)}'" }.join(", ")
    end

    define_method(:to_s) do
      demodularized_class = self.class.to_s.gsub(/^.*::/, '')
      values = initialized_attrs.map{ |a| "'#{self.send(a)}'" }.join(", ")
      demodularized_class + ": " + values
    end

    define_method(:==) do |other|
      self.class == other.class && initialized_attrs == other.initialized_attrs
    end

    define_method(:eql?) do |other|
      self == other
    end

    define_method(:hash) do
      self.class.hash ^ initialized_attrs.hash
    end
  end


  private

  def parse_targets(targets)
    attrs = {}
    targets.each do |target_or_hash|
      if target_or_hash.respond_to? :each
        target_or_hash.each do |target, source_message|
          attrs[target] = source_message
        end
      else
        attrs[target_or_hash] = target_or_hash
      end
    end
    attrs
  end

end

