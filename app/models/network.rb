require_dependency Rails.root.join('lib', 'custom_initializers').to_s

class Network
  extend CustomInitializers


  value_object_initializer :mining_effort => :effort,
                           :reward_amount => :reward

  def expected_reward
    MiningReward.new(reward, effort)
  end

end

