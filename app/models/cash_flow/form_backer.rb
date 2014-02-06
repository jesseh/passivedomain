require_dependency Rails.root.join('lib', 'passive_domain').to_s

module CashFlow
  class FormBacker

    extend PassiveDomain
    
    value_object_initializer do
      value(:objective).when_missing('').freeze_it
      value(:hash_rate).when_missing('').freeze_it
      value(:mining_electricity).when_missing('').freeze_it
      value(:cooling_electricity).when_missing('').freeze_it
      value(:electricity_rate).when_missing('').freeze_it
      value(:rig_utilization).when_missing('').freeze_it
      value(:pool_percentage).when_missing('').freeze_it
      value(:facility_fees).when_missing('').freeze_it
      value(:other_operating_costs).when_missing('').freeze_it
    end

    attr_reader :objective, :rig_hash_rate, :mining_electricity, :cooling_electricity,
                :electricity_rate, :rig_utilization, :pool_percentage,
                :facility_fees, :other_operating_costs
  end

end



