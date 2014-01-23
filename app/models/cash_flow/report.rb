
require_dependency Rails.root.join('lib', 'passive_domain').to_s

module CashFlow
  class Report
    extend PassiveDomain

    value_object_initializer do
      accept(Rig)
      accept(Mine)
      accept(Exchange)
      accept(Network)
    end

    attr_reader :network, :exchange

    def rig_capacity_value
      rig.capacity.gigahash_per_second
    end

    def rig_capacity_unit
      rig.capacity.gigahash_per_second_unit
    end

    def rig_efficiency_value
      rig.efficiency.kwh_per_ghash
    end

    def rig_efficiency_unit
      rig.efficiency.kwh_per_ghash_unit
    end

    def rig_utilization_value
      mine.rig_utilization.whole
    end

    def rig_utilization_unit
      mine.rig_utilization.whole_unit
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

    def revenue_value
      mine.revenue.monthly_value
    end

    def revenue_unit
      mine.revenue.monthly_unit
    end

    def pool_fees_value
      mine.pool_fees.monthly_value
    end

    def pool_fees_unit
      mine.pool_fees.monthly_unit
    end
  end
end

