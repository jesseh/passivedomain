require_dependency Rails.root.join('lib', 'passive_domain').to_s

module CashFlow
  class Mapper
    extend PassiveDomain

    value_object_initializer do
      value(:objective).                                        must_be( only.string ).freeze_it
      value(:electricity_rate_fractional => :electricity_rate). must_be( only.positive_number ).freeze_it
      value(:exchange_fee_percent).                             must_be( only.number_within(0...1) ).freeze_it
      value(:exchange_rate).                                    must_be( only.positive_number ).freeze_it
      value(:facility_cost_fractional => :facility_cost).       must_be( only.positive_number ).freeze_it
      value(:mining_difficulty => :mining_effort).              must_be( only.positive_number ).freeze_it
      value(:other_cost_fractional => :other_cost).             must_be( only.positive_number ).freeze_it
      value(:pool_fee_percent).                                 must_be( only.number_within(0...1) ).freeze_it
      value(:reward_amount_fractional => :reward_amount).       must_be( only.positive_integer ).freeze_it
      value(:rig_hash_rate).                                    must_be( only.positive_number ).freeze_it
      value(:rig_utilization).                                  must_be( only.number_within(0...1) ).freeze_it
      value(:watts_to_cool).                                    must_be( only.positive_number ).freeze_it
      value(:watts_to_mine).                                    must_be( only.positive_number ).freeze_it
    end

    attr_reader :exchange_rate, :objective

    def electricity_rate
      EnergyCost.new(UsCurrency.cents(@electricity_rate)).freeze
    end

    def exchange_fee_percent
      Percent.decimal(@exchange_fee_percent).freeze
    end

    def facility_cost
      UsDollarRate.per_month(UsCurrency.cents(@facility_cost)).freeze
    end

    def mining_effort
      MiningEffort.new(@mining_effort).freeze
    end

    def other_cost
      UsDollarRate.per_month(UsCurrency.cents(@other_cost)).freeze
    end

    def pool_fee_percent
      Percent.decimal(@pool_fee_percent).freeze
    end

    def reward_amount
      Bitcoin.new(@reward_amount).freeze
    end

    def rig_hash_rate
      HashRate.new(MiningHash.new(@rig_hash_rate)).freeze
    end

    def rig_utilization
      Percent.decimal(@rig_utilization).freeze
    end

    def watts_to_cool
      Power.watts(@watts_to_cool).freeze
    end

    def watts_to_mine
      Power.watts(@watts_to_mine).freeze
    end
  end
end
