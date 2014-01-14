require_dependency Rails.root.join('lib', 'number_with_units').to_s

class Energy
  include NumberWithUnits

  def self.kilowatt_hours(value)
    new(value.to_f)
  end

  def kilowatt_hours
    value
  end

  def base_unit
    "kilowatt hours"
  end

end
