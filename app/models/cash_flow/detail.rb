SECONDS_PER_HOUR         = 60 * 60
HOURS_PER_MONTH          = 24 * 365 / 12
HASH_SEARCH_SPACE        = 2**256
OFFSET_AT_MIN_DIFFICULTY = 0xffff * 2**208
KILOWATT_PER_WATT        = 1.0 / 1000



module CashFlow

  class Detail

    attr_accessor :rig_hash_rate,
                  :watts_to_mine,
                  :watts_to_cool,
                  :mining_difficulty,
                  :reward_amount,
                  :fiat_currency,
                  :electricity_rate,
                  :pool_fee_percent,
                  :facility_cost,
                  :other_cost,
                  :exchange_fee_percent,
                  :exchange_rate,
                  :rig_utilization


    def rig_capacity
      # unit: hash / hour
      rig_hash_rate * SECONDS_PER_HOUR
    end

    def rig_efficiency
      # unit: watt / hash
      (watts_to_mine + watts_to_cool) / rig_capacity
    end

    def expected_reward_rate
      # unit: Bitcoin / hour
      reward_amount * rig_capacity / expected_hash_to_find_block
    end

    def revenue
      # unit: Bitcoin / hour
      expected_reward_rate
    end

    def electricity_cost
      #unit: USD / hour
      electricity_rate * KILOWATT_PER_WATT * rig_efficiency * rig_capacity
    end

    def pool_cost
      #unit: Bitcoin / hour
       expected_reward_rate * pool_fee_percent
    end

    def revenue_exchange_cost
      # The cost of converting all Bitcoins earned, after pool fees
      # into the fiat currency.
      #
      # unit: Bitcoin / hour
      bitcoin_received * exchange_fee_percent
    end

    def operations_exchange_cost
      # The cost of converting enough Bitcoins into the fiat 
      # currency to pay for all the fiat-based cost.
      #
      # unit: USD
      monthly_fiat_based_cost * exchange_fee_percent
    end


    private

    def monthly_mining_hours
      HOURS_PER_MONTH * rig_utilization
    end

    def bitcoin_received
      reward_amount - pool_cost
    end

    def fiat_based_mining_cost
      electricity_cost
    end

    def fiat_based_operating_cost
      facility_cost + other_cost
    end

    def monthly_fiat_based_cost
      fiat_based_mining_cost * monthly_mining_hours + fiat_based_operating_cost
    end

    def expected_hash_to_find_block 
         mining_difficulty \
       * HASH_SEARCH_SPACE \
       / OFFSET_AT_MIN_DIFFICULTY # vim syntax coloring fix /
    end

    def money_builder
      self.class.money_builder
    end

  end

end

