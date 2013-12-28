module Problem
  class Store < ::Store

    def self.build
      self.new(Problem::Model)
    end

  end
end
