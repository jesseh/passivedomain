module Rig
  class Store

    class << self

      def find_by_id(id)
        Rig::Model.find_by_id(id)
      end

      def find_all
        Rig::Model.all
      end

    end

  end
end
