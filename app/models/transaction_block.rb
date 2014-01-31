require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class TransactionBlock
  extend PassiveDomain

  value_object_initializer do
    value.must_be( only.number )
  end

  include NumberWithUnits

  attr_reader :value

  def self.number(value)
    new(value)
  end

  def base_unit
    "blocks"
  end
end
