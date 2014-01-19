require_dependency Rails.root.join('lib', 'custom_initializers').to_s

class Network
  extend CustomInitializers


  value_object_initializer( 
    ask(:mining_effort, only.instance_of(MiningEffort)) => :effort,
    ask(:reward_amount, only.instance_of(Bitcoin))      => :reward
  )

  def expected_reward
    MiningReward.new(reward, effort)
  end

end

