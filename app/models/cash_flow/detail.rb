
require_dependency Rails.root.join('lib', 'custom_initializers').to_s

SECONDS_PER_HOUR         = 60 * 60
HOURS_PER_MONTH          = 24 * 365 / 12
HASH_SEARCH_SPACE        = 2**256
OFFSET_AT_MIN_DIFFICULTY = 0xffff * 2**208
KILOWATT_PER_WATT        = 1.0 / 1000



module CashFlow
  class Detail
    extend CustomInitializers

    attr_reader :rig, :mine, :network, :exchange

    private_attr_initializer 


    def initialize(data)
      initialize_private_attrs(data)
      @rig = Rig.new(data)
      @mine = Mine.new(data)
      @network = Network.new(data)
      @exchange = Exchange.new(data)
    end


    # def hourly_expected_reward_rate
    #   # unit: Bitcoin / hour
    #   reward_amount * rig_capacity / expected_hash_to_find_block
    # end

    # def hourly_revenue
    #   # unit: money / hour
    #   hourly_expected_reward_rate
    # end

    # def hourly_electricity_cost
    #   #unit: money / hour
    #   electricity_rate * KILOWATT_PER_WATT * rig_efficiency * rig_capacity
    # end

    # def hourly_pool_cost
    #   #unit: Bitcoin / hour
    #    hourly_expected_reward_rate * pool_fee_percent
    # end

    # def hourly_revenue_exchange_cost
    #   # The cost of converting all Bitcoins earned, after pool fees
    #   # into US Dollars.
    #   #
    #   # unit: money / hour
    #   hourly_bitcoin_received * exchange_fee_percent
    # end

    # def monthly_operations_exchange_cost
    #   # The cost of converting enough Bitcoins into US Dollars
    #   # to pay for all the US Dollar cost.
    #   #
    #   # unit: money
    #   monthly_fiat_based_cost * exchange_fee_percent
    # end


    private


    def monthly_mining_hours
      HOURS_PER_MONTH * rig_utilization
    end

    def hourly_bitcoin_received
      hourly_expected_reward_rate - hourly_pool_cost
    end

    def hourly_fiat_based_mining_cost
      hourly_electricity_cost
    end

    def monthly_fiat_based_operating_cost
      facility_cost + other_cost
    end

    def monthly_fiat_based_cost
      hourly_fiat_based_mining_cost * monthly_mining_hours + monthly_fiat_based_operating_cost
    end

    def expected_hash_to_find_block 
         mining_difficulty \
       * HASH_SEARCH_SPACE \
       / OFFSET_AT_MIN_DIFFICULTY # vim syntax coloring fix /
    end

  end

end

