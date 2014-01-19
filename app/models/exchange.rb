require_dependency Rails.root.join('lib', 'custom_initializers').to_s

class Exchange
  extend CustomInitializers

  value_object_initializer(
    ask(:exchange_fee_percent, only.instance_of(Percent)) => :fee,
    ask(:exchange_rate,        only.positive_number)      => :rate
  )

end

