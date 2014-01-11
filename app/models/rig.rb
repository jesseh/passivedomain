require_dependency Rails.root.join('lib', 'custom_initializers').to_s

class Rig
  extend CustomInitializers

  value_object_initializer :rig_hash_rate,
                           :watts_to_mine,
                           :watts_to_cool

  def capacity
    rig_hash_rate
  end

  def efficiency
    (watts_to_mine + watts_to_cool) / capacity
  end


  # Methods to be a value object
  
  def inspect
    "#{self.class} rig_hash_rate=#{rig_hash_rate}, watts_to_mine='#{watts_to_mine}', watts_to_cool='#{watts_to_cool}'"
  end
  
  def to_s
    "Rig: #{rig_hash_rate}, '#{watts_to_mine}' + #{watts_to_cool}'"
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
    [rig_hash_rate, watts_to_mine, watts_to_cool].freeze
  end
end

