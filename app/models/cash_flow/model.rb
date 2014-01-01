BITCOIN_CURRENCY = "BTC"

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

    private

    def money_builder
      self.class.money_builder
    end

  end

end

