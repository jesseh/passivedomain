require_dependency Rails.root.join('lib', 'custom_initializers').to_s

module CashFlow
  class UnitNumber
    extend CustomInitializers

    private_attr_initializer :value, :unit

    def to_s
      "#{value} #{unit}"
    end

    def ==(other)
      to_s == other.to_s
    end

    def eql?(other)
      self ==(other)
    end

    def hash
      to_s.hash
    end


  end

end
