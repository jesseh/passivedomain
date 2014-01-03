BITCOIN_CURRENCY = "BTC"


module CashFlow
  class Store 

    include ::Store

    def self.build
      self.new(CashFlow::Record, CashFlow::Detail)
    end

    def self.money_builder
      Money
    end

    def electricity_rate(record)
      money_builder.new(record.electricity_rate_fractional, record.fiat_currency)
    end

    def facility_cost(record)
      money_builder.new record.facility_cost_fractional, record.fiat_currency
    end

    def other_cost(record)
      money_builder.new record.other_cost_fractional, record.fiat_currency
    end

    def reward_amount(record)
      money_builder.new record.reward_amount_fractional, BITCOIN_CURRENCY
    end

    private

    def money_builder
      self.class.money_builder
    end

    def update_model(model_instance, record)
        model_instance.rig_hash_rate        = record.rig_hash_rate
        model_instance.watts_to_mine        = record.watts_to_mine
        model_instance.watts_to_cool        = record.watts_to_cool
        model_instance.mining_difficulty    = record.mining_difficulty
        model_instance.reward_amount        = reward_amount(record)
        model_instance.fiat_currency        = record.fiat_currency
        model_instance.electricity_rate     = electricity_rate(record)
        model_instance.pool_fee_percent     = record.pool_fee_percent
        model_instance.facility_cost        = facility_cost(record)
        model_instance.other_cost           = other_cost(record)
        model_instance.exchange_fee_percent = record.exchange_fee_percent
        model_instance.exchange_rate        = record.exchange_rate
        model_instance.rig_utilization      = record.rig_utilization
    end
  end
end
