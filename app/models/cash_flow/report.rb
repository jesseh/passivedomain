
require_dependency Rails.root.join('lib', 'custom_initializers').to_s

module CashFlow
  class Report
    extend CustomInitializers

    value_object_initializer Rig, Mine, Network, Exchange

    attr_reader :rig, :mine, :network, :exchange


    def expected_reward_rate
      network.expected_reward * rig.capacity
    end

  end
end

