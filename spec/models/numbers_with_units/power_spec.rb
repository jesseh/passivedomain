require "spec_helper"

describe NumbersWithUnits::Power do

  subject { described_class.watts(123) }

  it_behaves_like 'number with units'

  its(:to_s)  { should == '123 watts' }
end
