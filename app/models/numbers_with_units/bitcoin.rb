module NumbersWithUnits
  class Bitcoin
    include NumberWithUnits

    def self.amount(value)
      new(value)
    end

    def base_unit
      "Bitcoin"
    end
  end
end
