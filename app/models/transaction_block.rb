require_dependency Rails.root.join('lib', 'number_with_units').to_s

class TransactionBlock
  include NumberWithUnits

  def self.number(value)
    new(value)
  end

  def base_unit
    "blocks"
  end
end
