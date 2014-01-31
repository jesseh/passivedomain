module Canopy

  def self.included(other_mod)
    other_mod.extend ClassMethods
  end

  module ClassMethods
    def canopy_input(*args)
      @__canopy_input ||= Interface.new(*args)
    end

    def canopy_output(*args)
      @__canopy_output ||= Interface.new(*args)
    end

    def canopy_for(method_name)
      [canopy_input, canopy_output].any?{|canopy| canopy.match?(method_name) }
    end

    def method_added(method_name)
      if canopy_for(method_name) && !@canopy_calls_internal
        @canopy_calls_internal = true
        #This will call method_added itself, the condition prevents infinite recursion.
        Wrapper.inject(self, method_name)
        @canopy_calls_internal = false
      end
      super
    end
  end

  class Wrapper
    def self.inject(target, method_name)
      target.instance_eval do
        method_object = instance_method(method_name)
        define_method(method_name) do |*args, &block|
          # Call input interface
          target.canopy_input.validate(method_name,*args,&block)

          # the bind to self will put the context back to the class.
          result = method_object.bind(self).call(*args, &block)

          # Call output interface
          target.canopy_output.validate(method_name,result)

          result
        end
      end
    end
  end

  class Interface
    def initialize(opts={})
      @opts = opts
    end

    def match?(method_name)
      methods.include? method_name
    end

    def methods
      opts.keys
    end

    def validate(method_name,*args,&block)
      validator = opts[method_name]
      validator.call(*args,&block) if validator
    end

    private
    attr_reader :target_klass, :opts
  end

end
