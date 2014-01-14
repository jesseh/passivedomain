require_dependency Rails.root.join('lib', 'number_with_units').to_s

class Bitcoin
  DIGITS = 10

  include NumberWithUnits

  def self.amount(value)
    new(value)
  end

  def amount
    value
  end

  def base_unit
    "BTC"
  end

  def cast_new_value(value)
    BigDecimal.new(value, DIGITS)
  end
end
