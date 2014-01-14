require "spec_helper"
require "numbers_with_units"

describe Power do

  subject { described_class.watts(123) }

  it_behaves_like 'number with units'

  its(:to_s)  { should == '123.0 watts' }

  describe "#/ by hash_rate" do
    subject { described_class.watts(50) / HashRate.new(MiningHash.new(10)) }
    
    it { should == EnergyToHash.from_base_unit(5) }
  end
end
