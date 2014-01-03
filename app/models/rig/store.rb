module Rig
  class Store 

    include ::Store

    def self.build
      self.new(Rig::Model)
    end

    def initialize_model(model_instance, record)
      record
    end

  end
end
