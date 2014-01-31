

require_dependency Rails.root.join('lib', 'passive_domain').to_s

module CashFlow
  module Reports
    class Acquire
      extend PassiveDomain

      value_object_initializer do
        value(:objective).must_be only.equal_to 'acquire'
        value(Mine)
        value(Exchange)
      end

      include CashFlow::Report

      def units
        "Bitcoin per month"
      end

      private

      def convert(amount)
        exchange.to_bitcoin(amount)
      end
    end
  end
end
