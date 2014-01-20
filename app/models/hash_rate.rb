require_dependency Rails.root.join('lib', 'custom_initializers').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class HashRate
  extend CustomInitializers
  include NumberWithUnits

  SECONDS_PER_HOUR = 60 * 60

  def self.from_base_unit(value)
    self.new(MiningHash.from_base_unit(value))
  end

  def initialize(hashes, timespan=Timespan.seconds(1))
    raise_uncreatable(hashes, timespan) unless hashes.instance_of? MiningHash
    raise_uncreatable(hashes, timespan) unless timespan.instance_of? Timespan 
    
    @value = hashes.number / timespan.seconds
    freeze
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
