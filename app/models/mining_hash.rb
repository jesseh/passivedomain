require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'number_with_units').to_s

class MiningHash
  extend PassiveDomain

  value_object_initializer do
    value.must_be( only.number ).transform{ |raw| raw.freeze }
  end

  include NumberWithUnits

  GHASH_PER_HASH = 1 / 1E9

  attr_reader :value

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
