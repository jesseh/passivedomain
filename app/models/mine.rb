require_dependency Rails.root.join('lib', 'passive_domain').to_s

class Mine
  extend PassiveDomain

  value_object_initializer ask(:electricity_rate, only.instance_of(EnergyCost)),
                           ask(:pool_fee_percent, only.instance_of(Percent)),
                           ask(:facility_cost,    only.instance_of(UsDollarRate)),
                           ask(:other_cost,       only.instance_of(UsDollarRate)),
                           ask(:rig_utilization,  only.instance_of(Percent)),
                           Rig,
                           Network

  attr_reader :other_cost,
              :facility_cost,
              :rig_utilization,
              :revenue

  def revenue
    rig_utilization * (network.expected_reward * rig.capacity) 
  end

  def pool_fees
    pool_fee_percent * revenue
  end

  def electricity_cost
    #JESSE start here
  end

end

