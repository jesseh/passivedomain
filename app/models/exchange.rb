require_dependency Rails.root.join('lib', 'passive_domain').to_s

class Exchange
  extend PassiveDomain

  value_object_initializer do
    value( :exchange_fee_percent => :fee  ).must_be only.instance_of Percent
    value( :exchange_rate        => :rate ).must_be only.positive_number
  end

  attr_reader :rate

  def to_usd(amount)
    return UsCurrency.dollars(rate * amount.value) if amount.instance_of? Bitcoin
    return amount if amount.instance_of? UsCurrency
    raise(TypeError, "The type '#{amount.class} cannot be exchanged into US dollars.")
  end

  def to_usd_fee(amount)
    return UsCurrency.new(0) if amount.instance_of? UsCurrency
    return fee * to_usd(amount) 
  end

end

