require_dependency Rails.root.join('lib', 'passive_domain').to_s

module CashFlow
  class Mapper
    extend PassiveDomain

    value_object_initializer do

      value(:objective).
        must_be( only.string ).
        transform{|raw| raw.freeze }

      value(:electricity_rate_fractional => :electricity_rate).
        must_be( only.positive_number ).
        transform{|raw| EnergyCost.new(UsCurrency.cents(raw)) }

      value(:exchange_fee_percent).
        must_be( only.number_within(0...1) ).
        transform{|raw| Percent.decimal(raw) }

      value(:exchange_rate).
        must_be( only.positive_number )

      value(:facility_cost_fractional => :facility_cost).
        must_be( only.positive_number ).
        transform{|raw| UsDollarRate.per_month(UsCurrency.cents(raw)) }

      value(:mining_difficulty => :mining_effort).
        must_be( only.positive_number ).
        transform{|raw| MiningEffort.new(raw) }

      value(:other_cost_fractional => :other_cost).
        must_be( only.positive_number ).
        transform{ |raw| UsDollarRate.per_month(UsCurrency.cents(raw)) }

      value(:pool_fee_percent).
        must_be( only.number_within(0...1) ).
        transform{|raw| Percent.decimal(raw) }

      value(:reward_amount_fractional => :reward_amount).
        must_be( only.positive_integer ).
        transform{|raw| Bitcoin.new(raw) }

      value(:rig_hash_rate).
        must_be( only.positive_number ).
        transform{|raw| HashRate.new(MiningHash.new(raw)) }

      value(:rig_utilization).
        must_be( only.number_within(0...1) ).
        transform{|raw| Percent.decimal(raw) }

      value(:watts_to_cool).
        must_be( only.positive_number ).
        transform{|raw| Power.watts(raw) }

      value(:watts_to_mine).
        must_be( only.positive_number ).
        transform{|raw| Power.watts(raw) }
    end

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
                :exchange_rate,
                :pool_fee_percent,
                :objective


  end
end
