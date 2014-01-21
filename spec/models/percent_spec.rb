require "spec_helper"

describe Percent do

  subject { described_class.decimal(0.123) }

  its(:to_s)  { should eq('0.123') }
  its(:whole) { should eq(12.3) }
  its(:whole_unit) { should eq('%') }

  describe "#* by anything" do
    it { expect(described_class.new(0.50) * MiningHash.new(10)).to eq(MiningHash.new(5)) }
    it { expect(described_class.new(0.50) * Power.new(20)).to eq(Power.new(10)) }
  end
end
