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
  
  it { expect { subject.fee_in_usd(1) }.to raise_error }
  it { expect(subject.bitcoin_to_usd(Bitcoin.new(20))).to eq(UsCurrency.from_base_unit(3860)) }
  it { expect(subject.fee_in_usd(Bitcoin.new(20))).to eq(UsCurrency.from_base_unit(38.6)) }

end
