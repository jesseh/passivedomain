require "spec_helper"

describe CashFlow::Store do

  it_behaves_like "a store" do
    let(:active_record_class_name){ 'CashFlow::Record' }
  end

  describe ".money_builder" do
    let(:money_class){ double("Money class") }

    before { stub_const("Money", money_class) }

    subject { described_class.money_builder }

    it { should eql(money_class) }
  end

  describe "currency fields" do
    let(:money){ double("Money").as_null_object }
    let(:money_class){ double("Money class", :new => money, :add_rate => nil) }
    let(:record){ double("Record").as_null_object }
    let(:model){ double("Detail").as_null_object }
    let(:instance){ described_class.new(record, model) }

    before do
      allow( described_class ).to receive(:money_builder){ money_class }
      allow(record).to receive(:fiat_currency).and_return("USD") 
      allow(record).to receive(:exchange_rate).and_return(1)
      allow(record).to receive(:electricity_rate_fractional).and_return(30_00)
      allow(record).to receive(:facility_cost_fractional).and_return(30_00)
      allow(record).to receive(:other_cost_fractional).and_return(30_00)
      allow(record).to receive(:reward_amount_fractional).and_return(30_00)
    end

    describe "#electricity_rate" do
      subject! { instance.electricity_rate(record) }

      it{ expect( money_class ).to have_received(:new).with(30_00, "USD") }
      it{ should eql(money) }
    end

    describe "#facility_cost" do
      subject! { instance.facility_cost(record) }

      it{ expect( money_class ).to have_received(:new).with(30_00, "USD") }
      it{ should eql(money) }
    end
    
    describe "#other_cost" do
      subject! { instance.other_cost(record) }

      it{ expect( money_class ).to have_received(:new).with(30_00, "USD") }
      it{ should eql(money) }
    end

    describe "#reward_amount" do
      # NOTE: the reward is always in BTC
      subject! { instance.reward_amount(record) }

      it{ expect( money_class ).to have_received(:new).with(30_00, "BTC") }
      it{ should eql(money) }
    end
  end

end
