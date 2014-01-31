require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class BitcoinRate
  extend PassiveDomain

  value_object_initializer do
    value.must_be( only.number ).transform{ |raw| raw.freeze }
  end

  include NumberWithUnits

  attr_reader :value

  def initialize(currency, timespan=Timespan.new(1))
    unless currency.instance_of?(Bitcoin) && timespan.instance_of?(Timespan)
      raise TypeError, "BitcoinRate initialization requires Bitcoin and Timespan"
    end
    data = (currency.amount / timespan.hours)
    initialize_attrs(data)
  end


  def self.per_month(value)
    new(value, Timespan.month)
  end

  def self.per_hour(value)
    new(value, Timespan.hour)
  end

  def self.from_base_unit(value)
    new(Bitcoin.new(value), Timespan.hour)
  end



  def monthly_value
    Bitcoin.new(value * HOURS_PER_MONTH)
  end

  def to_s
    "%.4f BTC / hour" % value
  end

  def base_unit
    "BTC / hour"
  end
  
end

