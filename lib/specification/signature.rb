require_dependency Rails.root.join('lib', 'passive_domain').to_s

module Specification
  class Signature

    attr_reader :method_symbol, :arguments, :response

    def initialize(method_symbol, arguments=[], response=nil)
      @method_symbol = method_symbol
      @arguments = arguments
      @response = response
    end

    def sample_response
      response.standin_value
    end

    def response_defined?
      !response.nil?
    end

    def valid_response?(value)
      response.valid?(value)
    end

    def valid_arguments?(in_arguments)
      return false unless in_arguments.length == arguments.length

      arguments.each_with_index do |argument, i|
        return false unless argument.valid?(in_arguments[i])
      end
      true
    end

    def standin_arguments
      arguments.map(&:standin_value)
    end

  end
end

