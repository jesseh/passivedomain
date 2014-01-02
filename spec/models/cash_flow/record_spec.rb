require "spec_helper"

describe CashFlow::Record do

  describe ".money_builder" do
    let(:money_class){ double("Money class") }

    before { stub_const("Money", money_class) }

    subject { described_class.money_builder }

    it { should eql(money_class) }
  end

  describe "inputs" do
    describe "#fiat_currency" do
      before{ subject.fiat_currency = 'usd' }
      its(:fiat_currency) { should eql('usd') }
    end

    describe "#exchange_rate" do
      before{ subject.exchange_rate = 0.123 }
      its(:exchange_rate) { should eql(0.123) }
    end

    describe "#objective" do
      before{ subject.objective = 'an_objective' }
      its(:objective) { should eql('an_objective') }
    end

    describe "#rig_hash_rate" do
      before{ subject.rig_hash_rate = 5.0e09 }
      its(:rig_hash_rate) { should eql(5.0e09) }
    end

    describe "#watts_to_mine" do
      before{ subject.watts_to_mine = 5.0e09 }
      its(:watts_to_mine) { should eql(5.0e09) }
    end

    describe "#watts_to_cool" do
      before{ subject.watts_to_cool = 5.0e09 }
      its(:watts_to_cool) { should eql(5.0e09) }
    end

    describe "#electricity_rate_fractional" do
      before{ subject.electricity_rate_fractional = 5.0e09 }
      its(:electricity_rate_fractional) { should eql(5.0e09) }
    end

    describe "#rig_utilization" do
      before{ subject.rig_utilization = 0.123 }
      its(:rig_utilization) { should eql(0.123) }
    end

    describe "#pool_fee_percent" do
      before{ subject.pool_fee_percent = 0.123 }
      its(:pool_fee_percent) { should eql(0.123) }
    end

    describe "#facility_cost_fractional" do
      before{ subject.facility_cost_fractional = 5.0e09 }
      its(:facility_cost_fractional) { should eql(5.0e09) }
    end

    describe "#exchange_provider" do
      before{ subject.exchange_provider = 'some_provider' }
      its(:exchange_provider) { should eql('some_provider') }
    end

    describe "#exchange_fee_percent" do
      before{ subject.exchange_fee_percent = 0.123 }
      its(:exchange_fee_percent) { should eql(0.123) }
    end

    describe "#other_cost_fractional" do
      before{ subject.other_cost_fractional = 5.0e09 }
      its(:other_cost_fractional) { should eql(5.0e09) }
    end

    describe "#mining_difficulty" do
      before{ subject.mining_difficulty = 5.0e09 }
      its(:mining_difficulty) { should eql(5.0e09) }
    end

    describe "#reward_amount_fractional" do
      before{ subject.reward_amount_fractional = 5.0e09 }
      its(:reward_amount_fractional) { should eql(5.0e09) }
    end
  end

  describe "currency fields" do
    let(:money){ double("Money").as_null_object }
    let(:money_class){ double("Money class", :new => money, :add_rate => nil) }
    let(:instance){ described_class.new }

    before do
      instance.fiat_currency = "USD"
      instance.exchange_rate = 1
      allow( described_class ).to receive(:money_builder){ money_class }
    end

    describe "#electricity_rate" do
      before   { instance.electricity_rate_fractional = 30_00 }
      subject! { instance.electricity_rate }

      it{ expect( money_class ).to have_received(:new).with(30_00, "USD") }
      it{ should eql(money) }
    end

    describe "#facility_cost" do
      before   { instance.facility_cost_fractional = 30_00 }
      subject! { instance.facility_cost }

      it{ expect( money_class ).to have_received(:new).with(30_00, "USD") }
      it{ should eql(money) }
    end
    
    describe "#other_cost" do
      before   { instance.other_cost_fractional = 30_00 }
      subject! { instance.other_cost }

      it{ expect( money_class ).to have_received(:new).with(30_00, "USD") }
      it{ should eql(money) }
    end

    describe "#reward_amount" do
      # NOTE: the reward is always in BTC
      before   { instance.reward_amount_fractional = 30_00 }
      subject! { instance.reward_amount }

      it{ expect( money_class ).to have_received(:new).with(30_00, "BTC") }
      it{ should eql(money) }
    end
  end
end
