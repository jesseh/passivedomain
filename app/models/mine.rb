require_dependency Rails.root.join('lib', 'custom_initializers').to_s

class Mine
  extend CustomInitializers

  value_object_initializer :electricity_rate,
                           :pool_fee_percent,
                           :facility_cost,
                           :other_cost,
                           :rig_utilization

  attr_reader :other_cost
end

