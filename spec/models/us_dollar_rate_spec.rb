require "spec_helper"

describe UsDollarRate do

  subject { described_class.per_hour(UsCurrency.new(3)) }

  it_behaves_like 'number with units'

  its(:to_s)  { should == '3.00 USD / hour' }
  its(:monthly_value)  { should == 3.00 * 730 }
  its(:monthly_unit)  { should == 'USD / month' }

  it "can be created with per_month" do
    expect( described_class.per_month(UsCurrency.dollars(3 * 24 * 365 / 12)) ).to eq(subject)
  end
end
