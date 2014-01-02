module CashFlow
  class Store < ::Store

    def self.build
      self.new(CashFlow::Record)
    end

  end
end
