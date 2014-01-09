require "spec_helper"

describe NumbersWithUnits::UsDollarRate do

  subject { described_class.per_hour(123) }

  it_behaves_like 'number with units'

  its(:to_s)  { should == '123.00 USD / hour' }

  it "can be created with per_month" do
    expect( described_class.per_month(123 * 24 * 365 / 12) ).to eq(subject)
  end
end
