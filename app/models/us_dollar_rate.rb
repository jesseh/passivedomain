require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class UsDollarRate
  extend PassiveDomain

  value_object_initializer do
    value.
      must_be( only.instance_of(UsCurrency) ).
      transform{ |raw| (raw.dollars / Timespan.hour.hours).freeze }
  end


  include NumberWithUnits
  HOURS_PER_MONTH = 730

  attr_reader :value

  def self.per_month(value)
    new(value / Timespan.month.hours)
  end

  def self.per_hour(value)
    new(value)
  end

  def self.from_base_unit(value)
    new(UsCurrency.dollars(value))
  end

  def base_unit
    "USD / hour"
  end

  def to_s
    "%.2f USD / hour" % value
  end

  def monthly_value
    UsCurrency.dollars(value * HOURS_PER_MONTH)
  end

  def monthly_unit
    'USD / month'
  end

  
end
