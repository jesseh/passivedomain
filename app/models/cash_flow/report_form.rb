# Used to take input from HTTP params and populate a report object
require_dependency Rails.root.join('lib', 'passive_domain').to_s

class CashFlow::ReportForm
  extend PassiveDomain

  value_object_initializer do
    # value(:objective)
    value(:cooling_electricity => :watts_to_cool). must_be( only.positive_number )
    value(:electricity_rate).                      must_be( only.positive_number )
    value(:facility_fees => :facility_cost).       must_be( only.positive_number )
    value(:hash_rate => :rig_hash_rate).           must_be( only.positive_number )
    value(:mining_electricity => :watts_to_mine).  must_be( only.positive_number )
    value(:other_operating_costs).                 must_be( only.positive_number )
    value(:pool_percentage => :pool_fee_percent).  must_be( only.number_within(0...100) )
    value(:rig_utilization)
  end


  def watts_to_cool
    Power.watts(@watts_to_cool)
  end

  def watts_to_mine
    Power.watts(@watts_to_mine)
  end

  def rig_hash_rate
    HashRate.new(MiningHash.new(@rig_hash_rate), Timespan.second)
  end

  def facility_cost
    UsDollarRate.per_month(UsCurrency.cents(@facility_cost))
  end

  def electricity_rate
    EnergyCost.new(UsCurrency.cents(@electricity_rate))
  end

  def exchange_fee_percent
    Percent.decimal(0.05)
  end

  def facility_cost
    UsDollarRate.per_month(UsCurrency.cents(@facility_cost))
  end

  def other_operating_costs
    UsDollarRate.per_month(UsCurrency.cents(@other_operating_costs))
  end

  def pool_fee_percent
    Percent.whole(@pool_fee_percent)
  end

  def rig_utilization
    Percent.whole(@rig_utilization)
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
