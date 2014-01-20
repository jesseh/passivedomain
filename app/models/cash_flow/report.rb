
require_dependency Rails.root.join('lib', 'passive_domain').to_s

module CashFlow
  class Report
    extend PassiveDomain

    value_object_initializer Rig, Mine, Network, Exchange

    def rig_capacity_value
      rig.capacity.gigahash_per_second
    end

    def rig_capacity_unit
      rig.capacity.gigahash_per_second_unit
    end

    def rig_efficiency_value
      rig.efficiency.value
    end

    def rig_efficiency_unit
      rig.efficiency.base_unit
    end

    def other_cost_value
      mine.other_cost.monthly_value
    end

    def other_cost_unit
      mine.other_cost.monthly_unit
    end

    def facility_cost_value
      mine.facility_cost.monthly_value
    end

    def facility_cost_unit
      mine.facility_cost.monthly_unit
    end
  end
end

