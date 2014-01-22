module PassiveDomain
  module Cache
    # This is a hash-like object where the values are weak references that may be collected
    # by the garbage collector. See https://github.com/bdurand/ref/blob/master/lib/ref/soft_value_map.rb
    @@cache = Ref::SoftValueMap.new
    @@hits = 0
    @@misses = 0

    #TODO - catch the weakref kernel error if garbage collected before strong reference created.
    #TODO - handle block
    def cache_get(target_class, *args)
      key = args.dup << target_class
      value_wrapper = @@cache[key]
      if value_wrapper.nil?
        #@@misses += 1
        #puts "miss (#{@@hits}, #{@@misses}, #{(100.0 * @@hits / (@@hits +  @@misses)).round(0)}%)"
        return nil
      end
      #@@hits += 1
      #puts "hit (#{@@hits}, #{@@misses}, #{(100.0 * @@hits / (@@hits +  @@misses)).round(0)}%)"
      value_wrapper[0]
    end

    def cache_store(instance, *args)
      key = args.dup << instance.class
      # Array wrapper needed because instance is (should be) frozen.
      value_wrapper = [instance]
      @@cache[key] = value_wrapper
    end
  end
end
