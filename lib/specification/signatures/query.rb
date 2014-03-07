require_dependency Rails.root.join('lib', 'specification', 'signatures', 'base').to_s

module Specification
  module Signatures

    class Query
      include Signatures::Base

      def idempotent?
        true
      end
    end

  end
end
