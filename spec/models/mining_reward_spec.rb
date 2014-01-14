require "spec_helper"

describe MiningReward do

  subject { described_class.new(Bitcoin.new(25), MiningEffort.new(1_000_000)) }

  it_behaves_like 'number with units'

  its(:to_s)  { should eq('5.8E-24 Bitcoin / gigahash') }

  it { expect(subject * HashRate.from_base_unit(10)).to be }
end
