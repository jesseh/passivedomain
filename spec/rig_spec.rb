require "spec_helper"
require_dependency "numbers_with_units"

describe Rig do
  include NumbersWithUnits

  let(:data) { double("Data", { 
    rig_hash_rate:         hash_rate.per_second(123E9),
    watts_to_mine:         power.watts(33),
    watts_to_cool:         power.watts(81),
  }) }
  subject { described_class.new(data) } 


  its(:capacity) { should eq(data.rig_hash_rate) }
  its(:efficiency) { should eq(2.5745257452574526e-13) } 
end
