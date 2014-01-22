
require_dependency Rails.root.join('lib', 'passive_domain').to_s

module CashFlow
  class Report
    extend PassiveDomain

    value_object_initializer Mine

    def electricity_cost_value
      mine.electricity_cost.monthly_value
    end

    def electricity_cost_unit
      mine.electricity_cost.monthly_unit
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

