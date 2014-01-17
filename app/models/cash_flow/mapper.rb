require_dependency Rails.root.join('lib', 'custom_initializers').to_s

module CashFlow
  class Mapper 
    extend CustomInitializers

    value_object_initializer :rig_hash_rate,
                             :watts_to_mine,
                             :watts_to_cool,
                             :pool_fee_percent,
                             :rig_utilization,
                             :exchange_fee_percent,
                             :exchange_rate,
                             :mining_difficulty => :mining_effort,
                             :reward_amount_fractional => :reward_amount,
                             :other_cost_fractional => :other_cost,
                             :facility_cost_fractional => :facility_cost,
                             :electricity_rate_fractional => :electricity_rate





    attr_reader :rig_hash_rate,
                :electricity_rate,
                :facility_cost,
                :other_cost,
                :reward_amount,
                :mining_effort,
                :watts_to_mine,
                :watts_to_cool,
                :rig_utilization,
                :mining_effort,
                :exchange_fee_percent,
                :exchange_rate


    private

    def prepare_electricity_rate raw_value
      EnergyCost.new(UsCurrency.cents(raw_value))
    end

    def prepare_facility_cost raw_value
      UsDollarRate.per_month(UsCurrency.cents(raw_value))
    end

    def prepare_other_cost raw_value
      UsDollarRate.per_month(UsCurrency.cents(raw_value))
    end

    def prepare_reward_amount raw_value
      Bitcoin.new(raw_value)
    end

    def prepare_mining_effort raw_value
      MiningEffort.new(raw_value)
    end

    def prepare_rig_hash_rate raw_value
      HashRate.new(MiningHash.new(raw_value), Timespan.second)
    end

  end
end
