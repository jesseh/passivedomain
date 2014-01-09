module NumbersWithUnits
  class HashRate
    include NumberWithUnits

    SECONDS_PER_HOUR = 60 * 60
    GHASH_PER_HASH = 1 / 1E9

    def self.per_second(value)
      new(value)
    end

    def base_unit
      'hash / second'
    end

    def ghash_per_hour
      convert(SECONDS_PER_HOUR * GHASH_PER_HASH, 'ghash / hour', 8)
    end
  end
end
