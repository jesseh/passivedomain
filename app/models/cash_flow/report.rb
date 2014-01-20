
require_dependency Rails.root.join('lib', 'custom_initializers').to_s

module CashFlow
  class Report
    extend CustomInitializers

    value_object_initializer Rig, Mine, Network, Exchange

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
