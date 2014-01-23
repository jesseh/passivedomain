require_dependency Rails.root.join('lib', 'passive_domain').to_s

class Network
  extend PassiveDomain

  value_object_initializer do
    accept(:mining_effort).only{ instance_of(MiningEffort) }.to(:effort)
    accept(:reward_amount).only{ instance_of(Bitcoin)      }.to(:reward)
  end

  attr_reader :effort, :reward

  def expected_reward
    MiningReward.new(reward, effort)
  end

end

