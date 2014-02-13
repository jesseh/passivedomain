require_dependency Rails.root.join('lib', 'passive_domain').to_s

module Specification
  class Signature

    attr_reader :method, :arguments, :response

    def initialize(method, arguments, response)
      @method = method
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

