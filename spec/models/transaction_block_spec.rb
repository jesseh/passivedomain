require 'spec_helper'

describe TransactionBlock do

  subject { described_class.number(1.23) }

  it_behaves_like 'number with units'

  its(:to_s)  { should == '1.23 blocks' }
end
