require "spec_helper"

describe Exchange do

  it_behaves_like 'value object'

  let(:data) { double("Data", { 
    exchange_fee_percent:  Percent.decimal(0.01),
    exchange_rate:         193,
  }) }

  subject { described_class.new(data) } 
  
  its(:fee)     { should == Percent.decimal(0.01) }
  its(:rate)    { should == 193 }

  its(:inspect) { should == "Exchange: fee='0.01', rate='193'" }
  its(:to_s)    { should == "Exchange: fee='0.01', rate='193'" }
  
  describe "#to_usd and #to_usd_fee" do
    context "incoming Bitcoin" do
      let(:incoming) { Bitcoin.new(20) }
      it { expect(subject.to_usd(incoming)).to eq(UsCurrency.dollars(3860)) }
      it { expect(subject.to_usd_fee(incoming)).to eq(UsCurrency.dollars(38.60)) }
    end

    context "incoming US Dollars" do
      let(:incoming) { UsCurrency.dollars(20) }
      it { expect(subject.to_usd(incoming)).to eq(UsCurrency.dollars(20)) }
      it { expect(subject.to_usd_fee(incoming)).to eq(UsCurrency.dollars(0)) }
    end

    context "incoming Numeric" do
      it {  expect { subject.to_usd(20) }.to raise_error } 
    end
  end
end
