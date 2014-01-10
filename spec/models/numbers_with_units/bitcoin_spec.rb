require 'spec_helper'

describe NumbersWithUnits::Bitcoin do

  subject { described_class.amount(1.23) }

  it_behaves_like 'number with units'

  its(:to_s)  { should == '1.23 BTC' }
end
