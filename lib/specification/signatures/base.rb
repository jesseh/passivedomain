require_dependency Rails.root.join('lib', 'passive_domain').to_s

module Specification
  module Signatures
    module Base

      def initialize(method_symbol, arguments=[], response=nil, optional_arg_count=0)
        if optional_arg_count > arguments.size
          raise ArgumentError, "optional argument count (#{optional_arg_count}) exceeds length of argument list (#{arguments.size})"
        end

        @method_symbol = method_symbol
        @arguments = arguments
        @response = response
        @optional_arg_count = optional_arg_count
      end

      def method_symbol
        @method_symbol
      end

      def sample_response
        response.standin_value if response_defined?
      end

      def response_defined?
        !response.nil?
      end

      def valid_response?(value)
        !response_defined? || response.valid?(value)
      end

      def valid_arguments?(in_arguments)
        return false unless valid_arity?(in_arguments.length)

        in_arguments.each_with_index do |in_argument, i|
          return false unless arguments[i].valid?(in_argument)
        end
        true
      end

      def standin_arguments
        arguments.map(&:standin_value)
      end

      def idempotent?
        raise NotImplementedError
      end

      private

      attr_reader :arguments, :response, :optional_arg_count

      def valid_arity?(in_arity)
        arg_count_range.include? in_arity
      end

      def arg_count_range
        (arguments.length - optional_arg_count)..arguments.length
      end

    end
  end
end
