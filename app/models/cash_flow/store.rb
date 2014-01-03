BITCOIN_CURRENCY = "BTC"


module CashFlow
  class Store 

    include ::Store

    def self.build
      self.new(CashFlow::Record, CashFlow::Detail)
    end

    private

    def update_model(model_instance, record)
        model_instance.rig_hash_rate        = mapper.rig_hash_rate
        model_instance.watts_to_mine        = mapper.watts_to_mine
        model_instance.watts_to_cool        = mapper.watts_to_cool
        model_instance.mining_difficulty    = mapper.mining_difficulty
        model_instance.reward_amount        = mapper.reward_amount
        model_instance.fiat_currency        = mapper.fiat_currency
        model_instance.electricity_rate     = mapper.electricity_rate
        model_instance.pool_fee_percent     = mapper.pool_fee_percent
        model_instance.facility_cost        = mapper.facility_cost
        model_instance.other_cost           = mapper.other_cost
        model_instance.exchange_fee_percent = mapper.exchange_fee_percent
        model_instance.exchange_rate        = mapper.exchange_rate
        model_instance.rig_utilization      = mapper.rig_utilization
    end
  end
end
