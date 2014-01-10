module NumbersWithUnits
  class PowerPerHash
    include NumberWithUnits

    def self.factors(energy, hash_rate)
      unless energy.instance_of?(Power) && hash_rate.instance_of?(HashRate)
        raise_uncreatable(energy, hash_rate)
      end
      new(energy.value / hash_rate.value)
    end

    def base_unit
      '(watts / second) / hash'
    end

    def raise_uncreatable(factor_1, factor_2)
        raise TypeError, "#{self.class} cannot be created from #{factor_1.class} and #{factor_2.class}."
    end

  end
end
