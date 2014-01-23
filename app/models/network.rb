require_dependency Rails.root.join('lib', 'passive_domain').to_s

class Network
  extend PassiveDomain

  value_object_initializer do
    value(:mining_effort => :effort).must_be only.instance_of MiningEffort
    value(:reward_amount => :reward).must_be only.instance_of Bitcoin 
  end

  attr_reader :effort, :reward

  def expected_reward
    MiningReward.new(reward, effort)
  end

end

