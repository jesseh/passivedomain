module PassiveDomain
  class Only
    extend PassiveDomain

    def self.anything
      @anything ||= new(lambda{ |raw_value| true }, nil)
    end

    def self.instance_of(cls)
      @instance_of ||= {}
      @instance_of[cls] ||= new(lambda{ |raw_value| raw_value.instance_of?(cls) },
                               "instance of '#{cls.to_s}' required for %s.")
    end

    def self.number
      @number ||= new(lambda{ |raw_value| raw_value.kind_of?(Numeric) },
                      "numeric type required for %s." )
    end

    def self.equal_to(expected_value)
      @equal_to ||= {}
      @equal_to[expected_value] ||= new(lambda{ |raw_value| raw_value == expected_value },
                                        "%s must have the value '#{expected_value}'." )
    end

    def self.string
      @string ||= new(lambda{ |raw_value| raw_value.kind_of?(String) },
                      "string required for %s." )
    end

    def self.positive_integer
      @positive_integer ||= new(lambda{ |raw_value| raw_value.kind_of?(Integer) && raw_value >= 0 },
                               "positive integer required for %s." )
    end

    def self.positive_number
      @positive_number ||= new(lambda{ |raw_value| raw_value.kind_of?(Numeric) && raw_value >= 0 },
                               "positive number required for %s." )
    end

    def self.number_within(range)
      @number_within ||= {}
      @number_within[range] ||= new(lambda{ |raw_value| raw_value.kind_of?(Numeric) && range.include?(raw_value) },
                                    "positive number required for %s." )
    end


    def initialize(test_lambda, fail_message)
      @test_lambda = test_lambda
      @fail_message = fail_message.freeze
      freeze
    end

    def check(name, raw_value)
      unless test_lambda.call(raw_value)
        fail_message % name 
      end
    end

    attr_reader :test_lambda, :fail_message
    protected :test_lambda, :fail_message

    def inspect
      "#{self.class} test_lambda=#{test_lambda}, fail_message='#{fail_message}'"
    end
    
    def to_s
      inspect
    end

    def ==(other)
      other.instance_of?(self.class) && test_lambda == other.test_lambda && fail_message == other.fail_message
    end

    def eql?(other)
      self == other
    end

    def hash
      [self.class, test_lambda, fail_message].hash
    end

    end
end
