

require_dependency Rails.root.join('lib', 'passive_domain').to_s

module CashFlow
  module Reports
    class Extract
      extend PassiveDomain
      include CashFlow::Report

      value_object_initializer do
        value(:objective).must_be only.equal_to 'extract'
        value(Mine)
        value(Exchange)
      end


      def units
        "US Dollar per month"
      end

      def revenue_exchange_fees
        convert(exchange.to_usd_fee(mine.revenue.monthly_value)).value
      end

      def gross_margin
          super - revenue_exchange_fees
      end



      private

      def usd_based_operating_costs
        electricity_cost + facility_cost + other_cost
      end

      def convert(amount)
        exchange.to_usd(amount)
      end
    end
  end
end
