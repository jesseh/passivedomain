require "spec_helper"

describe NumbersWithUnits::RewardRate do

  subject { described_class.bitcoin_per_block(123) }

  it_behaves_like 'number with units'

  its(:to_s)  { should eq('123 Bitcoin / block') }
end
