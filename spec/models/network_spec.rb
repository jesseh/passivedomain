require "spec_helper"

describe Network do

  it_behaves_like 'value object'

  let(:data) { double("Data", { 
    mining_difficulty:     MiningEffort.new(1E5),
    reward_amount:         Bitcoin.new(1)
  }) }
  
  subject { described_class.new(data) } 

  # Use 'it', not 'its' because the latter accesses private methods without error.
  its(:expected_reward) { should eq(MiningReward.from_base_unit(1E-05)) }

end
