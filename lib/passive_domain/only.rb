module PassiveDomain
  class Only
    def anything
      lambda do |name,raw_value|
      end
    end

    def instance_of(cls)
      lambda do |name,raw_value|
        "instance of '#{cls.to_s}' required for #{name}." unless raw_value.instance_of?(cls)
      end
    end

    def number
      lambda do |name,raw_value|
        "numeric type required for #{name}." unless raw_value.kind_of?(Numeric)
      end
    end

    def string
      lambda do |name,raw_value|
        "string required for #{name}." unless raw_value.kind_of?(String)
      end
    end

    def positive_integer
      lambda do |name,raw_value|
        "positive integer required for #{name}." unless raw_value.kind_of?(Integer) && raw_value >= 0
      end
    end

    def positive_number
      lambda do |name,raw_value|
        "positive number required for #{name}." unless raw_value.kind_of?(Numeric) && raw_value >= 0
      end
    end

    def number_within(range)
      lambda do |name,raw_value|
        "positive number required for #{name}." unless raw_value.kind_of?(Numeric) && range.include?(raw_value)
      end
    end
  end
end
