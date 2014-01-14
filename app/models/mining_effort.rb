class MiningEffort
  DIGITS = 10

  include NumbersWithUnits::NumberWithUnits

  OFFSET_AT_MIN_DIFFICULTY = 0xffff * 2**208
  HASH_SEARCH_SPACE        = 2**256

  attr_reader :difficulty

  def self.difficulty(value)
    new(value)
  end

  def self.from_base_unit(value)
    new(1, value)
  end

  def initialize(difficulty, value=nil)
    @difficulty = difficulty
    if value.nil?
      @value = BigDecimal.new(@difficulty * HASH_SEARCH_SPACE / OFFSET_AT_MIN_DIFFICULTY, DIGITS)
    else
      @value = value
    end
    freeze
  end

  def gigahash
     value.to_f / 1E9
  end

  def to_s
    "%.2E #{base_unit}" % [value]
  end

  def base_unit
    "hash / block"
  end

end
