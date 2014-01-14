require 'spec_helper'

describe Bitcoin do

  subject { described_class.amount(1.23) }

  it_behaves_like 'number with units'

  its(:to_s)  { should == '1.23 BTC' }

  describe "is price to 10 digits" do
    subject { described_class.amount(1.23456789012345) }
    its(:to_s)   { should == '1.23456789 BTC' }
    its(:amount) { should == 1.23456789 }
    its(:value)  { should == 1.23456789 }
  end
end
