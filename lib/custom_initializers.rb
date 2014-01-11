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

require 'pry'

module CustomInitializers

  # Method similar to attr_accessor that defines the initializer for a class and sets up private attr_readers
  def private_attr_initializer(*attribute_targets)

    # Call initialize_private_attrs directly if overriding initialize.
    define_method(:initialize) do |data_obj|
      initialize_private_attrs(data_obj)
    end


    attr_targets = parse_targets(attribute_targets).freeze
    attrs = attr_targets.values.freeze

    define_method(:initialize_private_attrs) do |data_obj|
      attr_targets.each do |source_message, target_attr|
        instance_variable_set("@#{target_attr}", data_obj.send(source_message))
      end
      instance_variable_set(:@initialized_attrs, attrs)
    end

    attr_reader :initialized_attrs, :initialized_values
    protected :initialized_attrs, :initialized_values

    attrs.each do |attr|
      attr_reader attr
      private attr
    end

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
          attrs[target] = source_message
        end
      else
        attrs[target_or_hash] = target_or_hash
      end
    end
    attrs
  end

end

