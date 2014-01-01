module WhenToMine
  class Store < ::Store

    def self.build
      self.new(WhenToMine::Model)
    end

  end
end
