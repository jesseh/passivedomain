BITCOIN_CURRENCY         = "BTC"
SECONDS_PER_HOUR         = 60 * 60
GHASH_PER_HASH           = 1.0 / 1E9
HASH_SEARCH_SPACE        = 2**256
OFFSET_AT_MIN_DIFFICULTY = 0xffff * 2**208
KILOWATT_PER_WATT        = 1.0 / 1000



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
      #unit: fiat_currency / hour
      electricity_rate * KILOWATT_PER_WATT * rig_efficiency * rig_capacity
    end

    def pool_cost
      #unit: Bitcoin / hour
       expected_reward_rate * pool_fee_percent
    end

    def exchange_transaction_cost
      #unit: Bitcoin
      expected_reward_rate * exchange_fee_percent
    end

    private

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

