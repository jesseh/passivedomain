module PassiveDomain
  module InstanceMethods

    def inspect
      self.class.to_s + ': ' + initialized_attrs.zip(initialized_values).map { |a, v| "#{a}='#{v}'" }.join(", ")
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

    attr_reader :initialized_attrs
    protected :initialized_attrs

    def initialized_values
      initialized_attrs.map{|a| self.send(a.to_sym) }
    end
    protected :initialized_values
  end
end
