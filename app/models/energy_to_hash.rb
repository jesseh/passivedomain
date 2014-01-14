require_dependency Rails.root.join('lib', 'number_with_units').to_s

class EnergyToHash
  include NumberWithUnits

  def self.power_for_hash_rate(power, hash_rate)
    unless power.instance_of?(Power) && hash_rate.instance_of?(HashRate)
      raise_uncreatable(power, hash_rate)
    end
    new(power.watts / hash_rate.value)
  end

  def base_unit
    '(watts / second) / hash'
  end

  def raise_uncreatable(factor_1, factor_2)
      raise TypeError, "#{self.class} cannot be created from #{factor_1.class} and #{factor_2.class}."
  end

end
