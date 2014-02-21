require_dependency Rails.root.join('lib', 'passive_domain').to_s

module Specification
  class Signature

    attr_reader :method_symbol, :arguments, :response

    def initialize(method_symbol, arguments, response)
      @method_symbol = method_symbol
      @arguments = arguments
      @response = response
    end

    def sample_response
      response.standin_value
    end

    def valid_response?(value)
      response.valid?(value)
    end

    
    

  end
end
