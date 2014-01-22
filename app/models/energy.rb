require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class Energy
  extend PassiveDomain
  include NumberWithUnits

  def self.kilowatt_hours(value)
    new(value.to_f)
  end

  def self.power_timespan(power, timespan)
    unless power.instance_of?(Power) && timespan.instance_of?(Timespan)
      raise(TypeError, "Power and Timespan classes required") 
    end
    new(power.kilowatts * timespan.hours)
  end

  def kilowatt_hours
    value
  end

  def base_unit
    "kilowatt hours"
  end

  def *(other)
    if other.instance_of? EnergyCost
      return UsCurrency.new(value * other.value)
    end
    super
  end

end
