module PassiveDomain
  module InstanceMethods

    # When overriding initialize be sure to call initialize_attrs directly
    def initialize(data_obj)
      initialize_attrs(data_obj)
    end

    def inspect
      self.class.to_s + ': ' + self.class.attribute_values.zip(initialized_values).map { |a, v| "#{a}='#{v}'" }.join(", ")
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

    def initialize_attrs(data_obj)
      self.class.attribute_targets.each do |source, target_attr|
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
      freeze
    end

    def initialized_values
      self.class.attribute_values.map{|a| self.send(a.to_sym) }
    end

  end
end
