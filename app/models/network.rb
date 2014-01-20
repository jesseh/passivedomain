require_dependency Rails.root.join('lib', 'passive_domain').to_s

class Network
  extend PassiveDomain


  value_object_initializer( 
    ask(:mining_effort, only.instance_of(MiningEffort)) => :effort,
    ask(:reward_amount, only.instance_of(Bitcoin))      => :reward
  )

  def expected_reward
    MiningReward.new(reward, effort)
  end

end

