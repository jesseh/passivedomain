require_relative "input"

module PassiveDomain
  class Builder

    def initialize(*inputs,&block)
      @inputs = inputs.map{|source| Input.new(source) }
      self.instance_eval(&block) if block
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
