require_dependency Rails.root.join('lib', 'passive_domain').to_s

module CashFlow
  class Mapper
    extend PassiveDomain

    in_interface = Interface.new do
      value(:objective).                   must_be( only.string )
      value(:electricity_rate_fractional). must_be( only.positive_number )
      value(:exchange_fee_percent).        must_be( only.number_within(0...1) )
      value(:exchange_rate).               must_be( only.positive_number )
      value(:facility_cost_fractional).    must_be( only.positive_number )
      value(:mining_difficulty).           must_be( only.positive_number )
      value(:other_cost_fractional).       must_be( only.positive_number )
      value(:pool_fee_percent).            must_be( only.number_within(0...1) )
      value(:reward_amount_fractional).    must_be( only.positive_integer )
      value(:rig_hash_rate).               must_be( only.positive_number )
      value(:rig_utilization).             must_be( only.number_within(0...1) )
      value(:watts_to_cool).               must_be( only.positive_number )
      value(:watts_to_mine).               must_be( only.positive_number )
    end

    out_interface = Interface.new do
      value(:objective).         must_be( only.string )
      value(:electricity_rate).  must_be( only.instance_of(EnergyCost) )
      value(:exchange_fee).      must_be( only.instance_of(Percent) )
      value(:exchange_rate).     must_be( only.positive_number )
      value(:facility_cost).     must_be( only.instance_of(UsDollarRate) )
      value(:mining_difficulty). must_be( only.instance_of(MiningEffort) )
      value(:other_cost).        must_be( only.intance_of(UsDollarRate) )
      value(:pool_fee).          must_be( only.instance_of(Percent) )
      value(:reward_amount).     must_be( only.instance_of(Bitcoin) )
      value(:rig_hash_rate).     must_be( only.instance_of(HashRate) )
      value(:rig_utilization).   must_be( only.instance_of(Percent) )
      value(:watts_to_cool).     must_be( only.instance_of(Power) )
      value(:watts_to_mine).     must_be( only.intance_of(Power) )
    end

    value_object_initializer in_interface, out_interface

    attr_reader :exchange_rate, :objective

    def electricity_rate
      EnergyCost.new(UsCurrency.cents(@electricity_rate_fractional)).freeze
    end

    def exchange_fee
      Percent.decimal(@exchange_fee_percent).freeze
    end

    def facility_cost
      UsDollarRate.per_month(UsCurrency.cents(@facility_cost_fractional)).freeze
    end

    def mining_effort
      MiningEffort.new(@mining_difficulty).freeze
    end

    def other_cost
      UsDollarRate.per_month(UsCurrency.cents(@other_cost_fractional)).freeze
    end

    def pool_fee_percent
      Percent.decimal(@pool_fee_percent).freeze
    end

    def reward_amount
      Bitcoin.new(@reward_amount_fractional).freeze
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
