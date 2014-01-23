require_dependency Rails.root.join('lib', 'passive_domain').to_s

class Mine
  extend PassiveDomain

  value_object_initializer do
    value(:electricity_rate ).must_be only.instance_of EnergyCost
    value(:pool_fee_percent ).must_be only.instance_of Percent
    value(:facility_cost    ).must_be only.instance_of UsDollarRate
    value(:other_cost       ).must_be only.instance_of UsDollarRate
    value(:rig_utilization  ).must_be only.instance_of Percent
    value(Rig)
    value(Network)
  end

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
    rig.power * electricity_rate
  end

end

