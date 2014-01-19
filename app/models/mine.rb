require_dependency Rails.root.join('lib', 'custom_initializers').to_s

class Mine
  extend CustomInitializers

  value_object_initializer ask(:electricity_rate, only.instance_of(EnergyCost)),
                           ask(:pool_fee_percent, only.instance_of(Percent)),
                           ask(:facility_cost,    only.instance_of(UsDollarRate)),
                           ask(:other_cost,       only.instance_of(UsDollarRate)),
                           ask(:rig_utilization,  only.instance_of(Percent))

  attr_reader :other_cost,
              :facility_cost
end

