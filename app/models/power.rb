require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class Power
  extend PassiveDomain
  include NumberWithUnits

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
