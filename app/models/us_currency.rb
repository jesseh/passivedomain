require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s
require 'bigdecimal'

class UsCurrency
  extend PassiveDomain

  PRECISION = 9

  value_object_initializer do
    value.must_be( only.number ).transform{ |raw| BigDecimal(raw, PRECISION).freeze }
  end

  include NumberWithUnits

  attr_reader :value

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

end
