require "spec_helper"

describe CashFlow::Model do

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

  describe "outputs" do
    before do
      subject.rig_hash_rate               = 123E9
      subject.watts_to_mine               = 33
      subject.watts_to_cool               = 81
      subject.mining_difficulty           = 1180923195.25800
      subject.reward_amount_fractional    = 25
      subject.fiat_currency               = "USD"
      subject.electricity_rate_fractional = 25
      subject.pool_fee_percent            = 0.07
      subject.facility_cost_fractional    = 7300
      subject.other_cost_fractional       = 9700
      subject.exchange_fee_percent        = 0.07
      subject.exchange_rate               = 1
      subject.rig_utilization             = 0.50 
    end

    describe "#rig_capacity" do
      its(:rig_capacity) { should eq(123E9 * 60 * 60) } 
    end

    describe "#rig_efficiency" do
      its(:rig_efficiency) { should eq(2.5745257452574526e-13) } 
    end

    describe "#expected_reward_rate" do
      it { expect(subject.expected_reward_rate.fractional.round(5)).to eq(0.00218) }
      it { expect(subject.expected_reward_rate.currency_as_string).to eq("BTC") }
    end
    
    describe "#revenue" do
      it { expect(subject.revenue.fractional.round(5)).to eq(0.00218) }
      it { expect(subject.revenue.currency_as_string).to eq("BTC") }
    end

    describe "#electricity_cost" do
      it { expect(subject.electricity_cost.amount.round(5)).to eq(0.0285) }
      it { expect(subject.electricity_cost.currency_as_string).to eq("USD") }
    end

    describe "#pool_cost" do
      it { expect(subject.pool_cost.amount.round(5)).to eq(0.00015) }
      it { expect(subject.pool_cost.currency_as_string).to eq("BTC") }
    end

    describe "#revenue_exchange_cost" do
      it { expect(subject.revenue_exchange_cost.amount.round(5)).to eq(1.74999) }
      it { expect(subject.revenue_exchange_cost.currency_as_string).to eq("BTC") }
    end

    describe "#operations_exchange_cost" do
      it { expect(subject.operations_exchange_cost.amount.round(5)).to eq(12.62818) }
      it { expect(subject.operations_exchange_cost.currency_as_string).to eq("USD") }
    end
    
  end
end
