

require_dependency Rails.root.join('lib', 'passive_domain').to_s

module CashFlow
  module Reports
    class Empty
      extend PassiveDomain
      include CashFlow::Report

      value_object_initializer

      def units
        ''
      end

      def revenue
        ''
      end

      def pool_fees
        ''
      end

      def revenue_exchange_fees
        nil
      end

      def electricity_cost
        ''
      end

      def gross_margin
        ''
      end

      def facility_cost
        ''
      end

      def other_cost
        ''
      end

      def operating_exchange_fees
        ''
      end

      def ebitda
        ''
      end

    end
  end
end
