require "spec_helper"

describe CashFlow::Detail do

  before do
    subject.rig_hash_rate               = 123E9
    subject.watts_to_mine               = 33
    subject.watts_to_cool               = 81
    subject.mining_difficulty           = 1180923195.25800
    subject.reward_amount               = Money.new(25, "BTC")
    subject.fiat_currency               = "USD"
    subject.electricity_rate            = Money.new(25, "USD")
    subject.pool_fee_percent            = 0.07
    subject.facility_cost               = Money.new(7300, "USD")
    subject.other_cost                  = Money.new(9700, "USD")
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
