module Rig
  class Store < ::Store

    def self.build
      self.new(Rig::Model)
    end

  end
end
