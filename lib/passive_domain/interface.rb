require_dependency Rails.root.join('lib', 'passive_domain').to_s

module PassiveDomain
  class Interface
    extend ClassMethods

    IGNORED_METHODS = [:inputs, :input_targets, :initialize_attrs,
                       :assert_frozen, :initialized_values]

    # Instantiate with a class
    value_object_initializer do
      value(:inputs => :calls).
        must_be(only.instance_array(Input)).
        transform do |raw|
          raw.inject({}) do |collector, input| 
            collector[input.source] ||= [] 
            collector[input.source] << input.only if input.only
            collector
          end.freeze
        end

      value(:instance_methods => :responds_to).
        call_args(true).
        must_be(only.instance_array(Symbol)).
        transform do |raw| 
          methods = (raw - Object.instance_methods - IGNORED_METHODS).freeze
          methods
        end
    end

    attr_reader :calls, :responds_to

  end
end
