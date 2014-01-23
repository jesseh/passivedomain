# Used to take input from HTTP params and populate a report object
require_dependency Rails.root.join('lib', 'passive_domain').to_s

class CashFlow::ReportForm
  extend PassiveDomain

  value_object_initializer do
    value(:cooling_electricity => :watts_to_cool).
      must_be( only.positive_number ).
      transform{|raw| Power.watts(raw) }

    value(:electricity_rate).
      must_be( only.positive_number ).
      transform{|raw| EnergyCost.new(UsCurrency.cents(raw)) }

    value(:facility_fees => :facility_cost).
      must_be( only.positive_number ).
      transform{|raw| UsDollarRate.per_month(UsCurrency.cents(raw)) }

    value(:hash_rate => :rig_hash_rate).
      must_be( only.positive_number ).
      transform{|raw| HashRate.new(MiningHash.new(raw), Timespan.second) }

    value(:mining_electricity => :watts_to_mine).
      must_be( only.positive_number ).
      transform{|raw| Power.watts(raw) }

    # value(:objective)

    value(:other_operating_costs).
      must_be( only.positive_number ).
      transform{|raw| UsDollarRate.per_month(UsCurrency.cents(raw)) }

    value(:pool_percentage => :pool_fee_percent).
      must_be( only.number_within(0...100) ).transform{|raw| Percent.whole(raw) }

    value(:rig_utilization).transform{|i| Percent.whole(i) }
  end

  attr_reader :electricity_rate,
              :facility_cost,
              :other_cost,
              :pool_fee_percent,
              :rig_utilization,
              :watts_to_cool,
              :watts_to_mine,
              :rig_hash_rate

  def exchange_fee_percent
    Percent.decimal(0.05)
  end

  def exchange_rate
    59
  end

  def reward_amount
    Bitcoin.new(120)
  end

  def mining_effort
    MiningEffort.new(300000)
  end


end
