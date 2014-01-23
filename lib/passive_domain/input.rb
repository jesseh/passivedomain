module PassiveDomain
  class Input
    attr_reader :source, :validator, :prepare_block

    def initialize(source)
      @source = source
    end

    def only(&block)
      @validator = Only.new.instance_eval(&block)
      self
    end

    def prepare(&block)
      @prepare_block = block
      self
    end

    def to(target)
      @target = target
      self
    end

    def target
      underscore( (@target || source).to_s )
    end

    private

    # method from Rails ActiveSupport.
    def underscore(str)
      str.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end
  end
end
