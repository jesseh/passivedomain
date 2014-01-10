module NumbersWithUnits
  class Power
    include NumberWithUnits

    def self.watts(value)
      new(value)
    end

    def base_unit
      "watts"
    end

    def /(other)
      return PowerForHashing.factors(self, other) if other.instance_of?(HashRate)
      super
    end

    private

    def cast_new_value(value)
      value.to_f
    end
  end
end
