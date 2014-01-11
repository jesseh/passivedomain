require_dependency Rails.root.join('lib', 'custom_initializers').to_s

class Mine
  extend CustomInitializers

  value_object_initializer :electricity_rate,
                           :pool_fee_percent,
                           :facility_cost,
                           :other_cost,
                           :rig_utilization



  # Methods to be a value object
  
  def inspect
    "#{self.class} electricity_rate=#{electricity_rate}, pool_fee='#{pool_fee_percent}', facility_cost='#{facility_cost}', other_cost:'#{other_cost}', rig_utilization:'#{rig_utilization}'"
  end
  
  def to_s
    "Mine: #{electricity_rate}, '#{pool_fee_percent}', ..."
  end

  def ==(other)
    specs == other.specs
  end

  def eql?(other)
    self == other
  end

  def hash
    specs.hash
  end

  protected
  def specs
    [electricity_rate, pool_fee_percent, facility_cost, other_cost, rig_utilization].freeze
  end
end

