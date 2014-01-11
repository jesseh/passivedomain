require_dependency Rails.root.join('lib', 'custom_initializers').to_s

class Exchange
  extend CustomInitializers

  private_attr_initializer :exchange_fee_percent => :fee,
                           :exchange_rate => :rate

end

