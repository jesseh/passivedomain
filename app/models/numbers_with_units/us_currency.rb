require 'bigdecimal'

module NumbersWithUnits
  class UsCurrency
    PRECISION = 9

    include NumberWithUnits

    def self.dollars(value)
      new(value)
    end

    def self.cents(value)
      new(value) / 100
    end

    def to_s
      "%.2f USD" % [value]
    end

    def base_unit
      "USD"
    end

    private

    def cast_new_value(value)
      BigDecimal(value, PRECISION)
    end

  end
end
