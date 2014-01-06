require "spec_helper"

describe CashFlow::UnitNumber do
  let(:data) { double("Data", {
    value: 123,
    unit: 'yada / day'
  }) }
  subject { described_class.new(data) }

  its(:to_s) { should == '123 yada / day' }

  describe "is a value object" do
    let(:same_value) { described_class.new data }
    it { should eq(same_value) }
  end
end
