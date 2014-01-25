require "spec_helper"

describe CashFlow::Reports::Extract do
  let(:mining_difficulty) { 25 }
  let(:rig_hash_rate)     { 1E12 }
  let(:data) { double("Data", {
    electricity_rate:      EnergyCost.from_base_unit(25),
    exchange_fee_percent:  Percent.from_base_unit(0.07),
    exchange_rate:         1,
    facility_cost:         UsDollarRate.from_base_unit(73),
    mining_effort:         MiningEffort.from_base_unit(mining_difficulty),
    objective:             'extract'.freeze,
    other_cost:            UsDollarRate.from_base_unit(97),
    pool_fee_percent:      Percent.from_base_unit(0.50),
    reward_amount:         Bitcoin.from_base_unit(25),
    rig_hash_rate:         HashRate.from_base_unit(rig_hash_rate),
    rig_utilization:       Percent.from_base_unit(0.50),
    watts_to_cool:         Power.from_base_unit(81),
    watts_to_mine:         Power.from_base_unit(33),
  }) }
  subject { described_class.new(data) }

  it_should_behave_like("CashFlow::Report data"){ subject { data } }
  #it_should_behave_like("CashFlow::Report interface")

  its(:units)                   { should == "US Dollar per month" }
  its(:revenue)                 { should be_a_kind_of Numeric } #TODO figure out the math here
  its(:pool_fees)               { should be_a_kind_of Numeric }
  its(:electricity_cost)        { should be_a_kind_of Numeric }
  its(:operating_exchange_fees) { should be_nil }
  its(:revenue_exchange_fees)   { should be_a_kind_of Numeric }
  its(:gross_margin)            { should be_a_kind_of Numeric }
  its(:facility_cost)           { should be_a_kind_of Numeric }
  its(:other_cost)              { should be_a_kind_of Numeric }
  its(:ebitda)                  { should be_a_kind_of Numeric } #TODO figure out the math here

  #TODO - tests are missing here.
end
