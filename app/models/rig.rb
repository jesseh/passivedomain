require_dependency Rails.root.join('lib', 'custom_initializers').to_s

class Rig
  extend CustomInitializers

  private_attr_initializer :rig_hash_rate,
                           :watts_to_mine,
                           :watts_to_cool

  def capacity
    rig_hash_rate
  end

  def efficiency
    # unit: watt / hash
    (watts_to_mine + watts_to_cool) / capacity
  end

end

