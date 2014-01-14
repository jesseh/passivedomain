class TransactionBlock
  include NumbersWithUnits::NumberWithUnits

  def self.number(value)
    new(value)
  end

  def base_unit
    "blocks"
  end
end
