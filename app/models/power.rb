class Power
  include NumbersWithUnits::NumberWithUnits

  def self.watts(value)
    new(value)
  end

  def watts
    value
  end

  def base_unit
    "watts"
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
