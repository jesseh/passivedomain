module PassiveDomain
  class Ask
    def initialize(source, validator, prepare_block)
      @source        = source
      @validator     = validator
      @prepare_block = prepare_block
    end

    attr_reader :source, :validator, :prepare_block

    def value(data_obj)
      raw_value = data_obj.send(source)

      validation_message = validator.call(raw_value)
      raise(ValidationError, validation_message) if validation_message

      prepare_block.nil? ? raw_value : prepare_block.call(raw_value)
    end
  end
end
