require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class Percent
  extend PassiveDomain
  include NumberWithUnits

  def self.decimal(value)
    new(value)
  end

  def whole
    "#{value * 100}%"
  end

  def base_unit
    ""
  end
end
