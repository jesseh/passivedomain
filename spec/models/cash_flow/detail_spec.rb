require "spec_helper"
require_dependency "numbers_with_units"

describe CashFlow::Detail do
  include NumbersWithUnits

  let(:data) { double("Data", { 
    rig_hash_rate:         hash_rate.per_second(123E9),
    watts_to_mine:         electricity.watts(33),
    watts_to_cool:         electricity.watts(81),
    mining_difficulty:     1180923195.25800,
    reward_amount:         reward_rate.bitcoin_per_block(25),
    electricity_rate:      electricity_cost_rate.us_cents_per_kwh(25),
    pool_fee_percent:      percent.decimal(0.07),
    facility_cost:         us_dollar_rate.per_month(73),
    other_cost:            us_dollar_rate.per_month(97),
    exchange_fee_percent:  percent.decimal(0.07),
    exchange_rate:         1,
    rig_utilization:       percent.decimal(0.50),
  }) }
  subject { described_class.new(data) } 


  describe "#rig_capacity" do
    its(:rig_capacity) { should eq(data.rig_hash_rate) }
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
