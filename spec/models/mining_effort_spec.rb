require 'spec_helper'

describe MiningEffort do

  subject { described_class.difficulty(1_789_546_951) }

  it_behaves_like 'number with units'

  its(:to_s)  { should == '7.69E+18 hash / block' }
  its(:gigahash)  { should == 7686162910.740069 }
end
