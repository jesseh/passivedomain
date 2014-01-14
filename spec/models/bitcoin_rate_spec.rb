require "spec_helper"

describe BitcoinRate do

  subject { described_class.per_hour(Bitcoin.new(123.5)) }

  it_behaves_like 'number with units'

  its(:to_s)  { should == '123.50 BTC / hour' }

end
