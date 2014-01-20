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

  def self.extended(cl)
    # The fastest way to get a value object because it pulls from a cache.
    def cl.produce(data_obj)
      CustomInitializers.get_or_create(self, data_obj)
    end
  end


  class ValidationError < TypeError
  end

  # This is a hash-like object where the values are weak references that may be collected
  # by the garbage collector. See https://github.com/bdurand/ref/blob/master/lib/ref/soft_value_map.rb
  @@cache = Ref::SoftValueMap.new
  @@hits = 0
  @@misses = 0

  #TODO - catch the weakref kernel error if garbage collected before strong reference created.
  def self.get_or_create(target_class, data_obj)
    key = [data_obj, target_class]
    puts "Key: #{key.inspect}"
    value_wrapper = @@cache[key]
    if value_wrapper.nil?
      value_wrapper = [target_class.new(data_obj)]
      puts "just cached: #{value_wrapper.inspect}"
      @@cache[key] = value_wrapper
      @@misses += 1
      puts "miss (#{@@hits}, #{@@misses}, #{(100.0 * @@hits / (@@hits +  @@misses)).round(0)}%)"
    else
      @@hits += 1
      puts "hit (#{@@hits}, #{@@misses}, #{(100.0 * @@hits / (@@hits +  @@misses)).round(0)}%)"
    end
    value_wrapper[0]
  end

  class Only
    def anything
      lambda do |raw_value| 
      end
    end

    def instance_of(cls)
      lambda do |raw_value| 
        "instance of '#{cls.to_s}' required." unless raw_value.instance_of?(cls)
      end
    end

    def number
      lambda do |raw_value| 
        "numeric type required." unless raw_value.kind_of?(Numeric)
      end
    end

    def string
      lambda do |raw_value| 
        "string required." unless raw_value.kind_of?(String)
      end
    end

    def positive_integer
      lambda do |raw_value| 
        "positive integer required." unless raw_value.kind_of?(Integer) && raw_value >= 0
      end
    end

    def positive_number
      lambda do |raw_value| 
        "positive number required." unless raw_value.kind_of?(Numeric) && raw_value >= 0
      end
    end

    def number_within(range)
      lambda do |raw_value| 
        "positive number required." unless raw_value.kind_of?(Numeric) && range.include?(raw_value)
      end
    end
  end

  class Ask
    def initialize(source, validator, prepare_block)
      @source        = source
      @validator     = validator
      @prepare_block = prepare_block
    end

    attr_reader :source, :validator, :prepare_block

    def value(data_obj)
      raw_value = data_obj.send(source)

      validation_message = validator.call(raw_value)
      raise(ValidationError, validation_message) if validation_message

      prepare_block.nil? ? raw_value : prepare_block.call(raw_value)
    end
  end


  def ask(source, only=only.anything, &block)
    Ask.new(source, only, block)
  end

  def only(*args)
    Only.new
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
      attr_targets.each do |source, target_attr|
        value = begin
          if source.instance_of?(Ask) 
            source.value(data_obj)
          elsif source.respond_to?(:produce) 
            source.produce(data_obj) 
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

