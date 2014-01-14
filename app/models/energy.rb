class Energy
  include NumbersWithUnits::NumberWithUnits

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
