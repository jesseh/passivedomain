module PassiveDomain
  class Only
    def self.anything
      new(lambda{ |raw_value| true }, nil)
    end

    def self.instance_of(cls)
      new(lambda{ |raw_value| raw_value.instance_of?(cls) },
          "instance of '#{cls.to_s}' required for %s.")
    end

    def self.number
      new(lambda{ |raw_value| raw_value.kind_of?(Numeric) },
          "numeric type required for %s." )
    end

    def self.string
      new(lambda{ |raw_value| raw_value.kind_of?(String) },
          "string required for %s." )
    end

    def self.positive_integer
      new(lambda{ |raw_value| raw_value.kind_of?(Integer) && raw_value >= 0 },
        "positive integer required for %s." )
    end

    def self.positive_number
      new(lambda{ |raw_value| raw_value.kind_of?(Numeric) && raw_value >= 0 },
          "positive number required for %s." )
    end

    def self.number_within(range)
      new(lambda{ |raw_value| raw_value.kind_of?(Numeric) && range.include?(raw_value) },
          "positive number required for %s." )
    end

    def initialize(test_lambda, fail_message)
      @test_lambda = test_lambda
      @fail_message = fail_message
    end

    def check(name, raw_value)
      unless test_lambda.call(raw_value)
        fail_message % name 
      end
    end

    private

    attr_reader :test_lambda, :fail_message
  end
end
