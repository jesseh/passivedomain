require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class Percent
  extend PassiveDomain
  include NumberWithUnits

  def self.decimal(value)
    new(value)
  end

  def self.whole(value)
    new(value / 100)
  end

  def whole
    value * 100
  end

  def whole_unit
    '%'
  end

  def *(other)
    return other.class.from_base_unit(other.value * value) if other.respond_to?(:value)
    super
  end

  def base_unit
    ""
  end
end
