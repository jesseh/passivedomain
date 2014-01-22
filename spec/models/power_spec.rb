require "spec_helper"

describe Power do

  subject { described_class.watts(123) }

  it_behaves_like 'number with units'

  its(:to_s)       { should == '123.0 watts' }
  its(:watts)      { should == 123 }
  its(:kilowatts)  { should == 0.123 }

  describe "#* by timespan" do
    subject { described_class.watts(500) * Timespan.hour }
    
    it { should == Energy.from_base_unit(0.5) }
  end

  describe "#* by energy cost" do
    subject { described_class.watts(500) * EnergyCost.from_base_unit(20) }
    it { should == UsDollarRate.from_base_unit(10) }
  end


  describe "#/ by hash_rate" do
    subject { described_class.watts(50) / HashRate.new(MiningHash.new(10)) }
    
    it { should == EnergyToHash.from_base_unit(5) }
  end
end
