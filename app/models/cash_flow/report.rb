
require_dependency Rails.root.join('lib', 'passive_domain').to_s

module CashFlow
  class Report
    extend PassiveDomain

    value_object_initializer do
      value(Mine)
      value(Exchange) 
    end

    def revenue
      to_usd mine.revenue.monthly_value
    end

    def pool_fees
      to_usd mine.pool_fees.monthly_value
    end

    def exchange_fees
      to_usd exchange.to_usd_fee(revenue)
    end

    def electricity_cost
      to_usd mine.electricity_cost.monthly_value
    end

    def gross_margin
      revenue - electricity_cost - pool_fees - exchange_fees
    end

    def other_cost
      to_usd mine.other_cost.monthly_value
    end

    def facility_cost
      to_usd mine.facility_cost.monthly_value
    end

    def ebitda
        gross_margin - facility_cost - other_cost
    end



    private

    def to_usd(amount)
      exchange.to_usd(amount)
    end
  end
end

