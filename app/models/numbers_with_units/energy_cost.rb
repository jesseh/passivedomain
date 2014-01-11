module NumbersWithUnits
  class EnergyCost
    include NumberWithUnits

    def self.us_cents_per_kwh(value)
      new(UsCurrency.cents(value))
    end

    def base_unit
      "/ kWh"
    end
  end
end
