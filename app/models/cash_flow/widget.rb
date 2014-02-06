require_dependency Rails.root.join('lib', 'passive_domain').to_s

module CashFlow
  class Widget
    extend PassiveDomain
    
    value_object_initializer do
      value.must_be( only.string )
    end

    def html
      value
    end

    def response
      value
    end

  end
end

