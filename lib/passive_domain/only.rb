require_dependency Rails.root.join('lib', 'passive_domain').to_s

module PassiveDomain
  class Only
    extend PassiveDomain

    class AnyClass; end

    def self.anything
      @anything ||= new(lambda{ |raw_value| true },
                        nil,
                        ->{ [nil, "any string", :any_symbol, AnyClass, rand(-1000..1000)].sample }
                       )
    end

    def self.instance_of(cls)
      @instance_of ||= {}
      @instance_of[cls] ||= new(lambda{ |raw_value| raw_value.instance_of?(cls) },
                               "instance of '#{cls.to_s}' required for %s.",
                               lambda { 
                                  responder = Interface.for_class(cls).responder
                                  responder.nil? ? nil : cls.new(responder)
                               }) 
    end

    def self.number
      @number ||= new(lambda{ |raw_value| raw_value.kind_of?(Numeric) },
                      "numeric type required for %s.",
                      ->{ rand -1000000..1000000 }
                     )
    end

    def self.equal_to(expected_value)
      @equal_to ||= {}
      @equal_to[expected_value] ||= new(lambda{ |raw_value| raw_value == expected_value },
                                        "%s must have the value '#{expected_value}'.",
                                       expected_value)
    end

    def self.symbol
      @symbol ||= new(lambda{ |raw_value| raw_value.kind_of?(Symbol) },
                      "symbol required for %s.",
                      ->{ :standin_symbol })
    end

    def self.symbol_or_string
      @symbol_or_string ||= new(lambda{ |raw_value| raw_value.kind_of?(Symbol) ||
                                                    raw_value.kind_of?(String) },
                                "symbol or string required for %s.",
                                ->{ ["standin symbol or string", :standin_symbol_or_string].sample }
                               )
    end

    def self.string_or_nil
      @string_or_nil ||= new(lambda{ |raw_value|  raw_value.kind_of?(NilClass) ||
                                                  raw_value.kind_of?(String) },
                                "string or nil required for %s.",
                                ->{ [nil, "standin string or nil"].sample }
                            )
    end

    def self.string_symbol_or_nil
      @string_symbol_or_nil ||= new(lambda{ |raw_value| raw_value.kind_of?(NilClass) ||
                                                        raw_value.kind_of?(Symbol)  ||
                                                        raw_value.kind_of?(String) },
                                      "string, symbol, or nil required for %s.",
                                      ->{ [nil, "standin string symbol or nil", :standin_string_symbol_or_nil].sample }
                                   )
    end

    def self.string
      @string ||= new(lambda{ |raw_value| raw_value.kind_of?(String) },
                      "string required for %s.",
                      ->{ "standin string" }
                     )
    end

    def self.positive_integer
      @positive_integer ||= new(lambda{ |raw_value| raw_value.kind_of?(Integer) && raw_value >= 0 },
                                "positive integer required for %s.",
                                ->{ rand 0..100000 }
                               )
    end

    def self.positive_number
      @positive_number ||= new(lambda{ |raw_value| raw_value.kind_of?(Numeric) && raw_value >= 0 },
                               "positive number required for %s.",
                               ->{ rand 0..10000 * rand }
                              )
    end

    def self.number_within(range)
      @number_within ||= {}
      @number_within[range] ||= new(lambda{ |raw_value| raw_value.kind_of?(Numeric) && range.include?(raw_value) },
                                    "positive number required for %s.",
                                    ->{ rand range }
                                   )
    end

    def self.instance_array(cls)
      @instance_array ||= {}
      @instance_array[cls] ||= new(lambda{ |raw_value| raw_value.all? { |x| x.instance_of?(cls) } },
                                    "an array of #{cls} instances required for %s.",
                                  ->{ [] })  # empty array becaus the expected class may not be easy to instantiate.
    end

    attr_reader :test_lambda, :fail_message, :standin_value
    protected :test_lambda, :fail_message

    def initialize(test_lambda, fail_message, standin_lambda=nil)
      @test_lambda = test_lambda
      @fail_message = fail_message.freeze
      @standin_value = standin_lambda.respond_to?(:call) ? standin_lambda.call : nil
      freeze
    end

    def check(name, raw_value)
      unless test_lambda.call(raw_value)
        fail_message % name 
      end
    end


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
