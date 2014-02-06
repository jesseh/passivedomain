require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class EnergyCost
  extend PassiveDomain

  value_object_initializer do
    value.must_be( only.instance_of(UsCurrency) ).freeze_it
  end

  include NumberWithUnits

  def self.from_us_currency_and_energy(cost, energy)
    raise_uncreatable(cost, energy) unless cost.number_type ==  UsCurrency
    raise_uncreatable(cost, energy) unless energy.number_type == Energy
    
    data = cost / energy.kilowatt_hours
    self.new(data)
  end 

  def self.from_base_unit(amount)
    new(UsCurrency.dollars(amount))
  end

  def value
    (@value.dollars / Energy.kilowatt_hours(1).value).freeze
  end

  def base_unit
    "USD / kWh"
  end


  private

  def raise_uncreatable(factor_1, factor_2)
      raise TypeError, "#{self.class} cannot be created from #{factor_1.class} and #{factor_2.class}."
  end
end
