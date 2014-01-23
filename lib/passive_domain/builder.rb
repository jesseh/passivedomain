require_relative "input"

module PassiveDomain
  class Builder

    def initialize(&block)
      self.instance_eval(&block)
    end

    def accept(source)
      Input.new(source).tap{|t| inputs << t }
    end

    def attribute_values
      inputs.map(&:target)
    end

    def inputs
      @inputs ||= []
    end

  end
end
