require_dependency Rails.root.join('lib', 'custom_initializers').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class TransactionBlock
  extend CustomInitializers
  include NumberWithUnits

  def self.number(value)
    new(value)
  end

  def base_unit
    "blocks"
  end
end
