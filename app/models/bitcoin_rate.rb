class BitcoinRate
  include NumbersWithUnits::NumberWithUnits


  def self.per_month(value)
    new(value, Timespan.month)
  end

  def self.per_hour(value)
    new(value, Timespan.hour)
  end

  def self.from_base_unit(value)
    new(Bitcoin.new(value), Timespan.hour)
  end

  def initialize(currency, timespan=Timespan.new(1))
    unless currency.instance_of?(Bitcoin) && timespan.instance_of?(Timespan)
      raise TypeError, "BitcoinRate initialization requires Bitcoin and Timespan"
    end
    @value = (currency.amount / timespan.hours)
    freeze
  end

  def to_s
    "%.2f BTC / hour" % value
  end

  def base_unit
    "BTC / hour"
  end
  
end

