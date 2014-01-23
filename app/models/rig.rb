require_dependency Rails.root.join('lib', 'passive_domain').to_s

class Rig
  extend PassiveDomain

  value_object_initializer do
    accept(:rig_hash_rate).only{ instance_of(HashRate) }
    accept(:watts_to_mine).only{ instance_of(Power) }
    accept(:watts_to_cool).only{ instance_of(Power) }
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

