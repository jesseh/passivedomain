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

  describe "#hourly_rig_capacity" do
    its(:hourly_rig_capacity) { should eq(123E9 * 60 * 60) } 
  end

  describe "#rig_efficiency" do
    its(:rig_efficiency) { should eq(2.5745257452574526e-13) } 
  end

  describe "#hourly_expected_reward_rate" do
    it { expect(subject.hourly_expected_reward_rate.fractional.round(5)).to eq(0.00218) }
    it { expect(subject.hourly_expected_reward_rate.currency_as_string).to eq("BTC") }
  end
  
  describe "#hourly_revenue" do
    it { expect(subject.hourly_revenue.fractional.round(5)).to eq(0.00218) }
    it { expect(subject.hourly_revenue.currency_as_string).to eq("BTC") }
  end

  describe "#hourly_electricity_cost" do
    it { expect(subject.hourly_electricity_cost.amount.round(5)).to eq(0.0285) }
    it { expect(subject.hourly_electricity_cost.currency_as_string).to eq("USD") }
  end

  describe "#hourly_pool_cost" do
    it { expect(subject.hourly_pool_cost.amount.round(5)).to eq(0.00015) }
    it { expect(subject.hourly_pool_cost.currency_as_string).to eq("BTC") }
  end

  describe "#hourly_revenue_exchange_cost" do
    it { expect(subject.hourly_revenue_exchange_cost.amount.round(5)).to eq(0.00014) }
    it { expect(subject.hourly_revenue_exchange_cost.currency_as_string).to eq("BTC") }
  end

  describe "#monthly_operations_exchange_cost" do
    it { expect(subject.monthly_operations_exchange_cost.amount.round(5)).to eq(12.62818) }
    it { expect(subject.monthly_operations_exchange_cost.currency_as_string).to eq("USD") }
  end

end
