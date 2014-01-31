module PassiveDomain
  class Input
    attr_reader :source, :only, :prepare_block, :target

    def initialize(source_description=nil)
      params = Array(source_description).flatten

      @source = params.shift
      @target = params.shift
      @args = []
    end

    def must_be(only)
      raise TypeError, "Invalid only statement. Must be a kind of Only." unless only.kind_of?(Only)
      @only = only
      self
    end

    def send_args(*args)
      @args = args
      self
    end
    
    def transform(&block)
      @prepare_block = block
      self
    end

    def target
      underscore( (@target || source || :value).to_s )
    end

    def value(data_obj)
      raw = raw_value(data_obj)
      assert_valid raw
      prepare_value raw
    end

    private

    def raw_value(data_obj)
      if source.nil?
        data_obj
      elsif source.is_a? Class
        source.new(data_obj)
      else
        data_obj.public_send(source, *@args)
      end
    end

    def assert_valid(value)
      return unless only
      validation_message = only.check(source, value)
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
