module NumbersWithUnits
  class Power
    include NumberWithUnits

    def self.watts(value)
      new(value)
    end

    def base_unit
      "watts"
    end
  end
end
