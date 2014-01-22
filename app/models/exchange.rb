require_dependency Rails.root.join('lib', 'passive_domain').to_s

class Exchange
  extend PassiveDomain

  value_object_initializer(
    ask(:exchange_fee_percent, only.instance_of(Percent)) => :fee,
    ask(:exchange_rate,        only.positive_number)      => :rate
  )

  attr_reader :rate

  def bitcoin_to_usd(amount)
    raise(TypeError, "Bitcoin amount required for exchange.") unless amount.instance_of?(Bitcoin)
    UsCurrency.dollars(rate * amount.value)
  end

  def fee_in_usd(amount)
    fee * bitcoin_to_usd(amount) 
  end

end

