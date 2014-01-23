require_dependency Rails.root.join('lib', 'passive_domain').to_s

module CashFlow
  class Mapper
    extend PassiveDomain

    value_object_initializer do
      accept(:rig_hash_rate).only{ positive_number }.prepare{|raw|
        HashRate.new(MiningHash.new(raw), Timespan.second)
      }
      accept(:watts_to_mine).only{ positive_number }.prepare{|raw|
        Power.watts(raw)
      }
      accept(:watts_to_cool).only{ positive_number }.prepare{|raw|
        Power.watts(raw)
      }
      accept(:pool_fee_percent).only{ number_within(0...1) }.prepare{|raw|
        Percent.decimal(raw)
      }
      accept(:rig_utilization).only{ number_within(0...1) }.prepare{|raw|
        Percent.decimal(raw)
      }
      accept(:exchange_fee_percent).only{ number_within(0...1) }.prepare{|raw|
        Percent.decimal(raw)
      }
      accept(:exchange_rate).only{ positive_number }

      accept(:mining_difficulty).only{ positive_number }.prepare{|raw|
        MiningEffort.new(raw)
      }.to(:mining_effort)

      accept(:reward_amount_fractional).only{ positive_integer }.prepare{|raw|
        Bitcoin.new(raw)
      }.to(:reward_amount)

      accept(:other_cost_fractional).only{ positive_number }.prepare{ |raw|
        UsDollarRate.per_month(UsCurrency.cents(raw))
      }.to(:other_cost)

      accept(:facility_cost_fractional).only{ positive_number }.prepare{|raw|
        UsDollarRate.per_month(UsCurrency.cents(raw))
      }.to(:facility_cost)

      accept(:electricity_rate_fractional).only{ positive_number }.prepare{|raw|
        EnergyCost.new(UsCurrency.cents(raw))
      }.to(:electricity_rate)
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
                :exchange_rate


  end
end
