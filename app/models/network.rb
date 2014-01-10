require_dependency Rails.root.join('lib', 'custom_initializers').to_s

class Network
  extend CustomInitializers

  private_attr_initializer :mining_difficulty,
                           :reward_amount


  # Methods to be a value object
  
  def inspect
    "#{self.class} difficulty=#{mining_difficulty}, reward='#{reward_amount}'"
  end
  
  def to_s
    "Network: #{mining_difficulty}, '#{reward_amount}'"
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
    [mining_difficulty, reward_amount].freeze
  end
end

