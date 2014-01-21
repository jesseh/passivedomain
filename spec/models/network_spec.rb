require "spec_helper"

describe Network do

  it_behaves_like 'value object'

  let(:data) { double("Data", { 
    mining_effort:     MiningEffort.new(1E5),
    reward_amount:         Bitcoin.new(1)
  }) }
  
  subject { described_class.new(data) } 

  # Use 'it', not 'its' because the latter accesses private methods without error.
  it { expect(subject.expected_reward).to eq(MiningReward.from_base_unit(1E-05)) }
  it { expect(subject.effort).to eq(MiningEffort.new(1E5)) }
  it { expect(subject.reward).to eq(Bitcoin.new(1)) }

end
