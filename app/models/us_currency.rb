require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s
require 'bigdecimal'

class UsCurrency
  extend PassiveDomain
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
