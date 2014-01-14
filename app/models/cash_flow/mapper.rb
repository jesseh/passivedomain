require_dependency 'numbers_with_units'

module CashFlow
  class Mapper 

    attr_reader :record

    def initialize(record)
      @record = record
    end

    def rig_hash_rate
      HashRate.new(MiningHash.new(record.rig_hash_rate), Timespan.second)
    end

    def electricity_rate
      EnergyCost.new(UsCurrency.cents(record.electricity_rate_fractional))
    end

    def facility_cost
      UsDollarRate.per_month(UsCurrency.cents(record.facility_cost_fractional))
    end

    def other_cost
      UsDollarRate.per_month(UsCurrency.cents(record.other_cost_fractional))
    end

    def reward_amount
      Bitcoin.new(record.reward_amount_fractional)
    end

    def mining_effort
      MiningEffort.new(record.mining_difficulty)
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
