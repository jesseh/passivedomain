require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class EnergyCost
  extend PassiveDomain
  include NumberWithUnits

  def initialize(cost, energy=Energy.kilowatt_hours(1))
    raise_uncreatable(cost, energy) unless cost.instance_of? UsCurrency
    raise_uncreatable(cost, energy) unless energy.instance_of? Energy
    
    @value = cost.dollars / energy.kilowatt_hours
    freeze
  end

  def self.from_base_unit(amount)
    new(UsCurrency.dollars(amount))
  end

  def base_unit
    "USD / kWh"
  end


  private

  def raise_uncreatable(factor_1, factor_2)
      raise TypeError, "#{self.class} cannot be created from #{factor_1.class} and #{factor_2.class}."
  end
end
