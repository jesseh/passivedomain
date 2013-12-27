module Rig
  class Store

    class << self

      def find_by_id(id)
        Rig::Model.find_by_id(id)
      end

      def find_all
        Rig::Model.all
      end

      def create(form)
        if form.valid?
          Rig::Model.create! form.attributes
        else
          form
        end
      end

    end

  end
end
