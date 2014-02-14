module Canopy

  def self.included(other_mod)
    other_mod.extend ClassMethods
  end

  module ClassMethods
    def canopy_input(*args)
      @__canopy_input ||= Interface.new
      @__canopy_input.add(*args) do |method|
        Wrapper.inject(self, method)
      end
    end

    def canopy_output(*args)
      @__canopy_output ||= Interface.new
      @__canopy_output.add(*args) do |method|
        Wrapper.inject(self, method)
      end
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
        return unless instance_methods.include?(method_name)

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
    def initialize
      @store = {}
    end

    def add(options=nil,&block)
      return self unless options

      options.each do |method,validator|
        block.call(method) if validators_for(method).empty?
        validator_store(method, validator)
      end
      return self
    end

    def match?(method_name)
      methods.include? method_name
    end

    def methods
      store.keys
    end

    def validate(method_name,*args,&block)
      validators_for(method_name).each{|v| v.call(*args,&block) }
    end

    private
    attr_reader :target_klass, :store

    def validators_for(method_name)
      store[method_name] || []
    end

    def validator_store(method_name, validator)
      store[method_name] = validators_for(method_name) + [validator]
    end
  end

end
