require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'specification').to_s

class Rig
  extend PassiveDomain

  SOURCE_INTERFACE = Specification::Interface.new([
    Specification::Signature.new(:rig_hash_rate, [], Specification::Only.instance_of(HashRate) ),
    Specification::Signature.new(:watts_to_mine, [], Specification::Only.instance_of(Power) ),
    Specification::Signature.new(:watts_to_cool, [], Specification::Only.instance_of(Power) ),
    ])

  value_object_initializer SOURCE_INTERFACE

  attr_reader :rig_hash_rate, :watts_to_mine, :watts_to_cool

  def capacity
    rig_hash_rate
  end

  def efficiency
    (watts_to_mine + watts_to_cool) / capacity
  end

  def power
    watts_to_mine + watts_to_cool
  end

  
end

