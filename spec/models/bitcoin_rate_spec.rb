require "spec_helper"

describe BitcoinRate do

  subject { described_class.per_hour(Bitcoin.new(10)) }

  it_behaves_like 'number with units'

  its(:to_s)  { should == '10.0000 BTC / hour' }
  its(:monthly_value)  { should == 10.00 * 730 }
  its(:monthly_unit)  { should == 'BTC / month' }

end
