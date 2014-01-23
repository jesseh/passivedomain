require_relative "only"

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

    def value(data_obj)
      raw = raw_value(data_obj)
      assert_valid raw
      prepare_value raw
    end

    private

    def raw_value(data_obj)
      if source.is_a? Class
        source.new(data_obj)
      else
        data_obj.public_send(source)
      end
    end

    def assert_valid(value)
      return unless validator
      validation_message = validator.call(value)
      raise(ValidationError, validation_message) if validation_message
    end

    def prepare_value(value)
      return value unless prepare_block
      prepare_block.call(value)
    end

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
