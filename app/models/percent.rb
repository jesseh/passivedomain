require_dependency Rails.root.join('lib', 'number_with_units').to_s

class Percent
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
