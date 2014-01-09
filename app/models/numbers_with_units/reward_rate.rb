module NumbersWithUnits
  class RewardRate
    include NumberWithUnits

    def self.bitcoin_per_block(value)
      new(value)
    end

    def base_unit
      "Bitcoin / block"
    end
  end
end
