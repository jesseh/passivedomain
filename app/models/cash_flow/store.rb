module CashFlow
  class Store < ::Store

    def self.build
      self.new(CashFlow::Model)
    end

  end
end
