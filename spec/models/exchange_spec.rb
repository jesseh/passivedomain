require "spec_helper"

describe Exchange do
  include NumbersWithUnits

  it_behaves_like 'value object'

  let(:data) { double("Data", { 
    exchange_fee_percent:  percent.decimal(0.07),
    exchange_rate:         193,
  }) }

  subject { described_class.new(data) } 
  
  its(:fee)     { should == percent.decimal(0.07) }
  its(:rate)    { should == 193 }

  its(:inspect) { should == "Exchange: fee='0.07', rate='193'" }
  its(:to_s)    { should == "Exchange: fee='0.07', rate='193'" }

end
