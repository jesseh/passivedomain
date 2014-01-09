require_dependency 'numbers_with_units/us_currency'

module NumbersWithUnits
  class UsDollarRate
    include NumberWithUnits

    def self.per_month(value)
      new(value) / HOURS_PER_MONTH
    end

    def self.per_hour(value)
      new(value)
    end

    def base_unit
      "/ hour"
    end
    

    private

    def cast_new_value(value)
      value.instance_of?(UsCurrency) ? value : UsCurrency.dollars(value)
    end

  end
end
