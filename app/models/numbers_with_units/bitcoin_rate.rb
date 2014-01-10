require_dependency 'numbers_with_units/us_currency'

module NumbersWithUnits
  class BitcoinRate
    include NumberWithUnits

    def self.per_hour(value)
      new(value)
    end

    def base_unit
      "/ hour"
    end
    

    private

    def cast_new_value(value)
      value.instance_of?(Bitcoin) ? value : Bitcoin.amount(value)
    end

  end
end
