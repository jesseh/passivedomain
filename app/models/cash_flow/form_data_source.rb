module CashFlow
  class FormDataSource

    extend PassiveDomain
    
    value_object_initializer do
      value(:objective).
        must_be( only.string ).
        transform{ |raw| raw.freeze }

      value(:hash_rate => :rig_hash_rate).
        must_be( only.string ).
        transform{|raw| HashRate.new(MiningHash.new(raw.to_f.freeze)) }

      value(:mining_electricity => :watts_to_mine).
        must_be( only.string ).
        transform{|raw| Power.watts(raw.to_f.freeze) }

      value(:cooling_electricity => :watts_to_cool).
        must_be( only.string ).
        transform{|raw| Power.watts(raw.to_f.freeze) }

      value(:electricity_rate).
        must_be( only.string ).
        transform{|raw| EnergyCost.new(UsCurrency.cents(raw.to_f.freeze)) }

      value(:rig_utilization).
        must_be( only.string ).
        transform{|raw| Percent.decimal(raw.to_f.freeze) }

      value(:pool_percentage => :pool_fee_percent).
        must_be( only.string ).
        transform{|raw| Percent.decimal(raw.to_f.freeze) }

      value(:facility_fees => :facility_cost).
        must_be( only.string ).
        transform{|raw| UsDollarRate.per_month(UsCurrency.cents(raw.to_f.freeze)) }

      value(:other_operating_costs => :other_cost).
        must_be( only.string ).
        transform{|raw| UsDollarRate.per_month(UsCurrency.cents(raw.to_f.freeze)) }
    end

    attr_reader :objective, :rig_hash_rate, :watts_to_mine, :watts_to_cool,
                :electricity_rate, :rig_utilization, :pool_fee_percent,
                :facility_cost, :other_cost

    def mining_effort
      MiningEffort.new(100)
    end

    def reward_amount
      Bitcoin.new(25)
    end

    def exchange_fee_percent
      Percent.new(0.07)
    end

    def exchange_rate
      900
    end
  end
end
