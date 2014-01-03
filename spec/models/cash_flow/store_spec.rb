require "spec_helper"

describe CashFlow::Store do
  let(:money){ double("Money").as_null_object }
  let(:money_class){ double("Money class", 
    new: money, 
    add_rate: nil)}
  let(:model){ double("Detail").as_null_object }
  let(:instance){ described_class.new(record, model) }

  before do
    allow( described_class ).to receive(:money_builder){ money_class }
  end


  it_behaves_like "a store" do
    let(:active_record_class_name){ 'CashFlow::Record' }
  end

  describe ".money_builder" do
    before { stub_const("Money", money_class) }

    subject { described_class.money_builder }

    it { should eql(money_class) }
  end

  describe "#electricity_rate" do
    let(:record){ double("Record",
      fiat_currency: "USD",
      electricity_rate_fractional: 30_00,
    )}
    subject! { instance.electricity_rate(record) }

    it{ expect( money_class ).to have_received(:new).with(30_00, "USD") }
    it{ should eql(money) }
  end

  describe "#facility_cost" do
    let(:record){ double("Record",
      fiat_currency: "USD",
      facility_cost_fractional: 30_00,
    )}
    subject! { instance.facility_cost(record) }

    it{ expect( money_class ).to have_received(:new).with(30_00, "USD") }
    it{ should eql(money) }
  end
  
  describe "#other_cost" do
    let(:record){ double("Record",
      fiat_currency: "USD",
      other_cost_fractional: 30_00,
    )}
    subject! { instance.other_cost(record) }

    it{ expect( money_class ).to have_received(:new).with(30_00, "USD") }
    it{ should eql(money) }
  end

  describe "#reward_amount" do
    let(:record){ double("Record",
      reward_amount_fractional: 30_00
    )}
    subject! { instance.reward_amount(record) }

    it{ expect( money_class ).to have_received(:new).with(30_00, "BTC") }
    it{ should eql(money) }
  end
end
