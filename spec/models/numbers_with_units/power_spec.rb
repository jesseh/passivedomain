require "spec_helper"

module NumbersWithUnits
  describe Power do

    subject { described_class.watts(123) }

    it_behaves_like 'number with units'

    its(:to_s)  { should == '123.0 watts' }

    describe "#/ by hash_rate" do
      subject { described_class.watts(50) / HashRate.hash_per_second(10) }

      its(:value) { should eq(5) } 
      its(:class) { should be(PowerForHashing) }
    end
  end
end
