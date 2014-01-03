BITCOIN_CURRENCY = "BTC"


module CashFlow
  class Mapper 

    attr_reader :record

    def initialize(record)
      @record = record
    end

    def self.money_builder
      Money
    end

    def electricity_rate
      money_builder.new(record.electricity_rate_fractional, record.fiat_currency)
    end

    def facility_cost
      money_builder.new record.facility_cost_fractional, record.fiat_currency
    end

    def other_cost
      money_builder.new record.other_cost_fractional, record.fiat_currency
    end

    def reward_amount
      money_builder.new record.reward_amount_fractional, BITCOIN_CURRENCY
    end

    def method_missing(method_name, *args, &block)
      if record.respond_to?(method_name, true)
        record.public_send(method_name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(*args)
      record.respond_to?(*args)
    end

    private

    def money_builder
      self.class.money_builder
    end
  end
end
