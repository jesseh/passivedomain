BITCOIN_CURRENCY         = "BTC"
SECONDS_PER_HOUR         = 60 * 60
KILOWATT_PER_WATT        = 1.0 / 1000
GHASH_PER_HASH           = 1.0 / 1E9
HASH_SEARCH_SPACE        = 2**256
OFFSET_AT_MIN_DIFFICULTY = 0xffff * 2**208



module CashFlow

  class Model < ActiveRecord::Base

    self.table_name = "cash_flows"

    def self.money_builder
      Money
    end


    def electricity_rate
      money_builder.new electricity_rate_fractional, fiat_currency
    end

    def facility_cost
      money_builder.new facility_cost_fractional, fiat_currency
    end

    def other_cost
      money_builder.new other_cost_fractional, fiat_currency
    end

    def reward_amount
      money_builder.new reward_amount_fractional, BITCOIN_CURRENCY
    end

    def rig_capacity
      # unit: GHash / hour
      rig_hash_rate * SECONDS_PER_HOUR
    end

    def rig_efficiency
      # unit: kWh / GHash
      KILOWATT_PER_WATT * (watts_to_mine + watts_to_cool) / rig_capacity
    end

    def expected_reward_rate
      # unit: Bitcoin / hour

      reward_amount * rig_capacity / expected_ghash_per_block
    end

    private

    def expected_ghash_per_block 
        GHASH_PER_HASH     \
       * mining_difficulty \
       * HASH_SEARCH_SPACE \
       / OFFSET_AT_MIN_DIFFICULTY # vim syntax coloring fix /
    end

    def money_builder
      self.class.money_builder
    end

  end

end

