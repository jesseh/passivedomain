

require_dependency Rails.root.join('lib', 'passive_domain').to_s

module CashFlow
  module Reports
    class Retain
      extend PassiveDomain
      include CashFlow::Report

      value_object_initializer do
        value(:objective).must_be only.equal_to 'retain'
        value(Mine)
        value(Exchange)
      end


      def units
        "Bitcoin per month"
      end

      def operating_exchange_fees
        convert(exchange.to_usd_fee(bitcoin_to_cover_operating_costs)).value
      end

      def ebitda
          super - operating_exchange_fees
      end



      private

      def usd_based_operating_costs
        mine.electricity_cost.monthly_value + 
        mine.facility_cost.monthly_value + 
        mine.other_cost.monthly_value
      end

      def bitcoin_to_cover_operating_costs
        exchange.to_bitcoin(usd_based_operating_costs)
      end

      def convert(amount)
        exchange.to_bitcoin(amount)
      end
    end
  end
end
