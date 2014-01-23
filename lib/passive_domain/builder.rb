require_relative "input"
require_relative "only"

module PassiveDomain
  class Builder

    def initialize(*inputs,&block)
      @inputs = inputs.map{|source| Input.new(source) }
      self.instance_eval(&block) if block
    end

    def value(source_description)
      Input.new(source_description).tap{|t| inputs << t }
    end

    def only
      Only.new
    end

    def input_targets
      inputs.map(&:target)
    end

    def inputs
      @inputs ||= []
    end

  end
end
