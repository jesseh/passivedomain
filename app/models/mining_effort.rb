require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class MiningEffort
  extend PassiveDomain

  value_object_initializer do
    value.must_be( only.number ).transform{ |raw| raw.freeze }
  end

  include NumberWithUnits

  DIGITS = 10
  OFFSET_AT_MIN_DIFFICULTY = 0xffff * 2**208
  HASH_SEARCH_SPACE        = 2**256

  def initialize(difficulty, value=nil)
    @difficulty = difficulty
    if value.nil?
      data = BigDecimal.new(@difficulty * HASH_SEARCH_SPACE / OFFSET_AT_MIN_DIFFICULTY, DIGITS)
    else
      data = value
    end
    initialize_attrs(data)
  end

  attr_reader :difficulty, :value


  def self.difficulty(value)
    new(value)
  end

  def self.from_base_unit(value)
    new(1, value)
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
