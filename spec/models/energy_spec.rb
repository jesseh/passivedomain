require "spec_helper"

describe Energy do

  subject { described_class.kilowatt_hours(123) }

  it_behaves_like 'number with units'

  its(:to_s)            { should == '123.0 kilowatt hours' }
  its(:kilowatt_hours)  { should == 123.0 }

  describe "constructing with power and a timespan" do
    subject { described_class.power_timespan(Power.from_base_unit(1000), Timespan.hour) }
    its(:kilowatt_hours)  { should == 1 }
  end

  describe "#* by EnergyCost" do
    subject { described_class.kilowatt_hours(20) * EnergyCost.from_base_unit(10) }
    
    it { should == UsCurrency.from_base_unit(200) }
  end

end
