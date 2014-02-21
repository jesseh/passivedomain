require "spec_helper"

describe Rig do

  it_behaves_like 'value object'

  let (:data) { Rig::SOURCE_INTERFACE.responder({
    rig_hash_rate:         HashRate.new(MiningHash.new(1E9)),
    watts_to_mine:         Power.watts(40),
    watts_to_cool:         Power.watts(60),
  }) }
  subject { described_class.new(data) } 


  its(:capacity) { should eq(data.rig_hash_rate) }
  its(:efficiency) { should == EnergyToHash.from_base_unit(1e-07) } 
  its(:power) { should == Power.watts(100) } 

end
