require "spec_helper"

describe NumbersWithUnits::HashRate do
  subject { described_class.hash_per_second(123) }
  let(:expected_rate) { (123.0 * 60 * 60 / 1E9).round(8) }

  it_behaves_like 'number with units'

  its(:to_s)  { should == '123 hash / second' }
  its(:ghash_per_hour) { should == "#{expected_rate} ghash / hour" }

end
