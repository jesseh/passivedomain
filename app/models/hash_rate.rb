require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class HashRate
  extend PassiveDomain

  value_object_initializer do
    value.must_be( only.instance_of(MiningHash) )
  end

  include NumberWithUnits


  SECONDS_PER_HOUR = 60 * 60

  def self.from_base_unit(value)
    self.new(MiningHash.from_base_unit(value))
  end


  def value
    (@value.number / Timespan.second.seconds).freeze
  end

  def gigahash_per_second
    value / 1E9
  end

  def gigahash_per_second_unit
    'gigahash / second'
  end

  def hash_per_second
    value
  end

  def base_unit
    'hashes / second'
  end

  def gigahash_per_hour
    value * SECONDS_PER_HOUR / 1E9
  end

  def base_unit_number
    value
  end


  private

  def raise_uncreatable(factor_1, factor_2)
      raise TypeError, "#{self.class} cannot be created from #{factor_1.class} and #{factor_2.class}."
  end


end
