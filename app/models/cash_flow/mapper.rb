require_dependency 'numbers_with_units'

module CashFlow
  class Mapper 
    include NumbersWithUnits

    attr_reader :record

    def initialize(record)
      @record = record
    end

    def rig_hash_rate
      hash_rate.hash_per_second(record.rig_hash_rate)
    end

    def electricity_rate
      energy_cost.us_cents_per_kwh(record.electricity_rate_fractional)
    end

    def facility_cost
      us_dollar_rate.per_month(record.facility_cost_fractional)
    end

    def other_cost
      us_dollar_rate.per_month(record.other_cost_fractional)
    end

    def reward_amount
      reward_rate.bitcoin_per_block(reward_amount_fractional)
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
