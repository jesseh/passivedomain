require_dependency Rails.root.join('lib', 'passive_domain').to_s

class Rig
  extend PassiveDomain

  value_object_initializer do
    source( :rig_hash_rate ).must_be only.instance_of HashRate
    source( :watts_to_mine ).must_be instance_of Power
    source( :watts_to_cool ).must_be only.instance_of Power
  end

  def capacity
    rig_hash_rate
  end

  def efficiency
    (watts_to_mine + watts_to_cool) / capacity
  end

  def power
    watts_to_mine + watts_to_cool
  end

  
end

