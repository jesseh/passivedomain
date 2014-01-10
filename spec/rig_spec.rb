require "spec_helper"
require_dependency "numbers_with_units"

describe Rig do
  include NumbersWithUnits

  let(:data) { double("Data", { 
    rig_hash_rate:         hash_rate.hash_per_second(10),
    watts_to_mine:         power.watts(40),
    watts_to_cool:         power.watts(60),
  }) }
  subject { described_class.new(data) } 


  its(:capacity) { should eq(data.rig_hash_rate) }
  its("efficiency.value") { should eq(10) } 
  its("efficiency.class") { should be(NumbersWithUnits::PowerPerHash) }
end
