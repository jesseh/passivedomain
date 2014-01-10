require "spec_helper"

describe NumbersWithUnits::BitcoinRate do

  subject { described_class.per_hour(123.5) }

  it_behaves_like 'number with units'

  its(:to_s)  { should == '123.5 BTC / hour' }
end
