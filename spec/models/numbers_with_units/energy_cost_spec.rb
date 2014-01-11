require "spec_helper"

describe NumbersWithUnits::EnergyCost do

  subject { described_class.us_cents_per_kwh(123) }

  it_behaves_like 'number with units'

  its(:to_s)  { should == '1.23 USD / kWh' }
end
