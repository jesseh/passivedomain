require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class Power
  extend PassiveDomain

  value_object_initializer do
    value.must_be( only.number ).transform{ |raw| raw.to_f.freeze }
  end


  include NumberWithUnits

  attr_reader :value

  def self.watts(value)
    new(value)
  end

  def watts
    value
  end

  def kilowatts
    value / 1000
  end

  def base_unit
    "watts"
  end

  def *(other)
    return Energy.power_timespan(self, other) if other.instance_of?(Timespan)
    return UsDollarRate.per_hour(UsCurrency.dollars(kilowatts * other.value)) if other.instance_of?(EnergyCost)
    super
  end

  def /(other)
    return EnergyToHash.power_for_hash_rate(self, other) if other.instance_of?(HashRate)
    super
  end

  private

  def cast_new_value(value)
    value.to_f
  end
end
