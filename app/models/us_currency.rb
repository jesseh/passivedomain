require_dependency Rails.root.join('lib', 'custom_initializers').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s
require 'bigdecimal'

class UsCurrency
  extend CustomInitializers
  include NumberWithUnits

  PRECISION = 9

  def self.dollars(value)
    new(value)
  end

  def self.cents(value)
    new(value) / 100
  end

  def to_s
    "%.2f USD" % [value]
  end

  def dollars
    value
  end

  def base_unit
    "USD"
  end

  private

  def cast_new_value(value)
    BigDecimal(value, PRECISION)
  end

end
