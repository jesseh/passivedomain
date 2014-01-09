require "spec_helper"

describe NumbersWithUnits::Percent do

  subject { described_class.decimal(0.123) }

  it_behaves_like 'number with units'

  its(:to_s)  { should eq('0.123') }
  its(:whole) { should eq('12.3%') }
end
