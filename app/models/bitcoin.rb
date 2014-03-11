require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'specification').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class Bitcoin
  extend PassiveDomain

  DIGITS = 10

  INTERFACE = Specification::Interface.new([
               Specification::Signatures::Query.new(:value, [], Specification::Only.number),
               Specification::Signatures::Query.new(:amount, [], Specification::Only.number),
               Specification::Signatures::Query.new(:base_unit, [], Specification::Only.string),
              ])

  value_object_initializer do
    value.must_be( only.number ).freeze_it
  end

  include NumberWithUnits


  def value
    BigDecimal(@value, DIGITS).freeze
  end


  def self.amount(value)
    new(value)
  end

  def amount
    value
  end

  def base_unit
    "BTC"
  end

end
