require_dependency Rails.root.join('lib', 'number_with_units').to_s

class UsDollarRate
  include NumberWithUnits
  HOURS_PER_MONTH = 730

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

  def monthly_value
    value * HOURS_PER_MONTH
  end

  def monthly_unit
    'USD / month'
  end

  
end
