module CashFlow

  class Model < ActiveRecord::Base

    self.table_name = "cash_flows"

    def self.money_builder
      Money
    end

    private

    def money_builder
      self.class.money_builder
    end

  end

end

