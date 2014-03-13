require_dependency Rails.root.join('lib', 'specification', 'signatures', 'base').to_s

module Specification
  module Signatures

    class Initializer
      include Signatures::Base

      def initialize(arguments=[], optional_arg_count=0)
        super(:initialize, arguments, nil, optional_arg_count)
      end

      def idempotent?
        false
      end
    end

  end
end
