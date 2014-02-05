require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class Bitcoin
  extend PassiveDomain

  DIGITS = 10

  value_object_initializer do
    value.must_be( only.number ).transform{ |raw| BigDecimal(raw, DIGITS).freeze }
  end

  include NumberWithUnits

  attr_reader :value



  def self.amount(value)
    new(value)
  end

  def amount
    value
  end

  def base_unit
    "BTC"
  end

end
