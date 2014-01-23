require_relative "ask"
require_relative "only"
require_relative "input"

module PassiveDomain
  class Builder

    def initialize(&block)
      self.instance_eval(&block)
    end

    def accept(source)
      Input.new(source).tap{|t| inputs << t }
    end

    def attribute_targets
      Hash[inputs.map{|input|
        if input.source.is_a? Symbol
          [Ask.new(input.source, input.validator, input.prepare_block), input.target]
        else
          [input.source, input.target]
        end
      }]
    end

    def attribute_values
      attribute_targets.values
    end

    private

    def inputs
      @inputs ||= []
    end

  end
end
