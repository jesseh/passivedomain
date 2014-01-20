require_dependency Rails.root.join('lib', 'custom_initializers').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class MiningHash
  extend CustomInitializers
  include NumberWithUnits

  GHASH_PER_HASH = 1 / 1E9

  def initialize(number)
    raise(TypeError, "Mining hash requires a Numeric") unless number.kind_of? Numeric
    @value = number
    freeze
  end

  def giga
    "%.2E gigahashes" % gigahash_number
  end

  def number
    value
  end

  def gigahash_number
    value * GHASH_PER_HASH
  end

  def base_unit
    "hashes"
  end

end
