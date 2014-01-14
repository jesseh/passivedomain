require "spec_helper"

describe UsCurrency do

  subject { described_class.dollars(1.23) }

  it_behaves_like 'number with units'

  its(:to_s)  { should eq('1.23 USD') }
  its(:dollars)  { should eq(1.23) }

  it "can be created from dollars" do
    expect( described_class.dollars(1.23) ).to eq subject
  end

  it "can be created from cents" do
    expect( described_class.cents(123) ).to eq subject
  end
end
