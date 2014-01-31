module NumberWithUnits
  HOURS_PER_MONTH = 24 * 365 / 12 # hours/day * days in year / months in year
  SECONDS_PER_HOUR = 60 * 60 


  attr_reader :value


  # Require the factory methods
  def self.included(cl)
    def cl.from_base_unit(value)
      new(value)
    end
  end

  def inspect
    "#{self.class} value=#{value}, base_unit='#{base_unit}'"
  end
  
  def to_s
    join_char = base_unit.blank? ? '' : ' '
    [value, base_unit].join(join_char)
  end

  def number_type
    self.class
  end

  def ==(other)
    other.instance_of?(self.class) && value == other.value && base_unit == other.base_unit
  end

  def eql?(other)
    self == other
  end

  def hash
    (value.hash ^ base_unit.hash).hash
  end

  def *(other)
    raise_incompatible(other, :*) unless other.kind_of?(Numeric)
    self.class.from_base_unit(operate_on_value(:*, other))
  end

  def /(other)
    if other.instance_of?(self.class)
      value / other.value
    else
      raise_incompatible(other, :/) unless other.kind_of?(Numeric)
      self.class.from_base_unit(operate_on_value(:/, other))
    end
  end

  def +(other)
    if other.instance_of?(self.class)
      self.class.from_base_unit(operate_on_value(:+, other.value))
    else
      raise_incompatible(other, :+)
    end
  end

  def -(other)
    raise_incompatible(other, :-) unless other.instance_of?(self.class)
    self.class.from_base_unit(operate_on_value(:-, other.value))
  end

  def base_unit
    raise "Including class must set the base unit."
  end



  private

  def cast_new_value(value)
    value
  end

  def convert(multiplier, unit_string, precision=0)
    out_value = (value * multiplier).round(precision)
    "#{out_value} #{unit_string}" 
  end

  def raise_incompatible(other, op)
      raise TypeError, "#{self.class} and #{other.class} are incompatible for #{op.to_s} operation."
  end

  def operate_on_value(op, other)
    begin
      value.send(op, other)
    rescue TypeError
      raise_incompatible(other, op)
    end
  end

end
