class UsDollarRate
  include NumbersWithUnits::NumberWithUnits

  def self.per_month(value)
    new(value, Timespan.month)
  end

  def self.per_hour(value)
    new(value, Timespan.hour)
  end

  def self.from_base_unit(value)
    new(UsCurrency.dollars(value), Timespan.hour)
  end


  def initialize(currency, timespan=Timespan.new(1))
    unless currency.instance_of?(UsCurrency) && timespan.instance_of?(Timespan)
      raise TypeError, "UsDollarRate requires UsCurrency and Timespan"
    end
    @value = (currency.dollars / timespan.hours)
    freeze
  end

  def base_unit
    "USD / hour"
  end

  def to_s
    "%.2f USD / hour" % value
  end

  
end
