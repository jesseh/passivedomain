require_dependency Rails.root.join('lib', 'custom_initializers').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class Timespan
  extend CustomInitializers
  include NumberWithUnits

  def self.second
    new(1)
  end

  def self.hour
    new(60*60)
  end

  def self.month
    new(60*60*24*365/12)
  end

  def self.seconds(number)
    new(number)
  end

  def initialize(number)
    unless number.kind_of?(Numeric)
      raise TypeError, "Timespan requires Numeric type." 
    end
    @value = number
    freeze
  end

  def seconds
    value
  end

  def hours
    value / (60*60)
  end

  def base_unit
    "seconds"
  end
end
