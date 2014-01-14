
require_dependency Rails.root.join('lib', 'custom_initializers').to_s

module CashFlow
  class Detail
    extend CustomInitializers

    value_object_initializer Rig, Mine, Network, Exchange


    def expected_reward_rate
      network.expected_reward * rig.capacity
    end

  end
end

