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
    
    def target
      underscore( (@target || source || :value).to_s ).to_sym
    end

    def when_missing(given)
      @when_missing = given
      self
    end

    def freeze_it
      @freeze_it = true
      self
    end

    def value(data_obj)
      raw = raw_value(data_obj)
      raw.freeze if @freeze_it
      assert_valid raw
      raw
    end

    private

    def raw_value(data_obj)
      if source.nil?
        data_obj
      elsif source.is_a? Class
        source.new(data_obj)
      elsif instance_variable_defined?(:@when_missing) 
        @when_missing unless data_obj.respond_to?(source)
      else
        data_obj.public_send(source, *@args)
      end
    end

    def assert_valid(value)
      return unless only
      validation_message = only.check(source, value)
      raise(ValidationError, validation_message) if validation_message
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
