require_dependency Rails.root.join('lib', 'specification', 'signatures', 'base').to_s

module Specification
  module Signatures

    class Command
      include Signatures::Base

      def initialize(*args, &block)
        @idempotent = false
        super
      end

      attr_writer :idempotent

      def idempotent?
        @idempotent
      end
    end

  end
end
