require "spec_helper"

describe CashFlow::Detail do
  let(:data) { double("Data", { 
    rig_hash_rate:         123E9,
    watts_to_mine:         33,
    watts_to_cool:         81,
    mining_difficulty:     1180923195.25800,
    reward_amount:         Money.new(25, "BTC"),
    fiat_currency:         "USD",
    electricity_rate:      Money.new(25, "USD"),
    pool_fee_percent:      0.07,
    facility_cost:         Money.new(7300, "USD"),
    other_cost:            Money.new(9700, "USD"),
    exchange_fee_percent:  0.07,
    exchange_rate:         1,
    rig_utilization:       0.50,
  }) }
  subject { described_class.new(data) } 

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
