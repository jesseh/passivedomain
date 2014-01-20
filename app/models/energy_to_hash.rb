require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class EnergyToHash
  extend PassiveDomain
  include NumberWithUnits

  def self.power_for_hash_rate(power, hash_rate)
    unless power.instance_of?(Power) && hash_rate.instance_of?(HashRate)
      raise_uncreatable(power, hash_rate)
    end
    new(power.watts / hash_rate.value)
  end

  def base_unit
    '(watts seconds) / hash'
  end

  def kwh_per_ghash
    1E9 * value / (NumberWithUnits::SECONDS_PER_HOUR * 1E3)
  end

  def kwh_per_ghash_unit
    'kwh / gigahash'
  end

  def raise_uncreatable(factor_1, factor_2)
      raise TypeError, "#{self.class} cannot be created from #{factor_1.class} and #{factor_2.class}."
  end

end
