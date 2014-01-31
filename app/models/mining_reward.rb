require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class MiningReward
  extend PassiveDomain

  DIGITS = 10

  value_object_initializer do
    value.must_be( only.number ).transform{ |raw| raw.freeze }
  end

  include NumberWithUnits


  def initialize(reward_per_block, effort_per_block)
    unless reward_per_block.instance_of?(Bitcoin) && effort_per_block.instance_of?(MiningEffort)
      raise(TypeError, "MiningReward instantiation requires Bitcoin and MiningEffort types.") 
    end
    data = BigDecimal(reward_per_block.value / effort_per_block.value, DIGITS) / 1E9
    data.freeze
    initialize_attrs(data)
  end

  attr_reader :value

  def self.from_base_unit(value)
    new(Bitcoin.amount(value), MiningEffort.new(1))
  end


  def *(other)
    return BitcoinRate.per_hour(Bitcoin.new(value) / other.gigahash_per_hour) if other.instance_of?(HashRate)
    super
  end

  def base_unit
    "Bitcoin / gigahash"
  end

  def to_s
    "%.1E #{base_unit}" % [value]
  end

  def ==(other)
    other.instance_of?(self.class) && value.round(10) == other.value.round(10) && base_unit == other.base_unit
  end

end
