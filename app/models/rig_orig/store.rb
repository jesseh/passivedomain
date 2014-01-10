module RigOrig
  class Store 

    include ::Store

    def self.build
      self.new(Rig::Model)
    end

    def update_model(model_instance, record)
      record
    end

  end
end
