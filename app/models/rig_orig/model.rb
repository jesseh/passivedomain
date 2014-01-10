module RigOrig

  class Model < ActiveRecord::Base

    self.table_name = "rigs"

    def self.money_builder
      Money
    end

    def price
      money_builder.new price_fractional, price_currency
    end

    private

    def money_builder
      self.class.money_builder
    end

  end

end
