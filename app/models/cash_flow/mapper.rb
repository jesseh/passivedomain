require_dependency Rails.root.join('lib', 'custom_initializers').to_s

module CashFlow
  class Mapper 
    extend CustomInitializers

    value_object_initializer :rig_hash_rate,
                             # :watts_to_mine,
                             # :watts_to_cool,
                             :mining_difficulty => :mining_effort,
                             :reward_amount_fractional => :reward_amount,
                             # :pool_fee_percent,
                             :other_cost_fractional => :other_cost,
                             # :exchange_fee_percent,
                             # :exchange_rate,
                             # :rig_utilization,
                             :facility_cost_fractional => :facility_cost,
                             :electricity_rate_fractional => :electricity_rate





    attr_reader :rig_hash_rate,
                :electricity_rate,
                :facility_cost,
                :other_cost,
                :reward_amount,
                :mining_effort



    attr_reader :record

    def initialize(record)
      @record = record
      initialize_attrs(record)
    end


    def prepare_electricity_rate raw_value
      EnergyCost.new(UsCurrency.cents(raw_value))
    end

    def prepare_facility_cost raw_value
      UsDollarRate.per_month(UsCurrency.cents(record.facility_cost_fractional))
    end

    def prepare_other_cost raw_value
      UsDollarRate.per_month(UsCurrency.cents(record.other_cost_fractional))
    end

    def prepare_reward_amount raw_value
      Bitcoin.new(record.reward_amount_fractional)
    end

    def prepare_mining_effort raw_value
      MiningEffort.new(record.mining_difficulty)
    end

    private

    def prepare_rig_hash_rate raw_value
      HashRate.new(MiningHash.new(raw_value), Timespan.second)
    end

  end
end
