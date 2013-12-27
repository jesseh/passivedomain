module Rig
  class Store

    def self.build
      self.new(Rig::Model)
    end

    def initialize(active_record_class)
      @active_record_class = active_record_class
    end

    def find_by_id(id)
      active_record_class.find_by_id(id)
    end

    def find_by_name(name)
      active_record_class.find_by_name(name)
    end

    def find_all
      active_record_class.all
    end

    def create(form)
      if form.valid?
        active_record_class.create! form.attributes
      else
        form
      end
    end

    private

    attr_reader :active_record_class

  end
end
