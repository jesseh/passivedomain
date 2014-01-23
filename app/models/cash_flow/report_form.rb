# Used to take input from HTTP params and populate a report object
require_dependency Rails.root.join('lib', 'passive_domain').to_s

class CashFlow::ReportForm
  extend PassiveDomain

  value_object_initializer do
    accept(:cooling_electricity).only{ positive_number }.prepare{|raw|
      Power.watts(raw)
    }.to(:watts_to_cool)

    accept(:electricity_rate).only{ positive_number }.prepare{|raw|
      EnergyCost.new(UsCurrency.cents(raw))
    }

    accept(:facility_fees).only{ positive_number }.prepare{|raw|
      UsDollarRate.per_month(UsCurrency.cents(raw))
    }.to(:facility_cost)

    accept(:hash_rate).only{ positive_number }.prepare{|raw|
      HashRate.new(MiningHash.new(raw), Timespan.second)
    }.to(:rig_hash_rate)

    accept(:mining_electricity).only{ positive_number }.prepare{|raw|
      Power.watts(raw)
    }.to(:watts_to_mine)

    # accept(:objective)

    accept(:other_operating_costs).only{ positive_number }.prepare{|raw|
      UsDollarRate.per_month(UsCurrency.cents(raw))
    }

    accept(:pool_percentage).only{ number_within(0...100) }.prepare{|raw|
      Percent.whole(raw)
    }.to(:pool_fee_percent)

    accept(:rig_utilization).prepare{|i| Percent.whole(i) }
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
