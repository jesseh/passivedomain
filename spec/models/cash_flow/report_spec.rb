require "spec_helper"

describe CashFlow::Report do
  let(:mining_difficulty) { 25 }
  let(:rig_hash_rate)     { 1E12 }
  let(:data) { double("Data", {
    rig_hash_rate:         HashRate.from_base_unit(rig_hash_rate),
    watts_to_mine:         Power.from_base_unit(33),
    watts_to_cool:         Power.from_base_unit(81),
    mining_effort:         MiningEffort.from_base_unit(mining_difficulty),
    reward_amount:         Bitcoin.from_base_unit(25),
    electricity_rate:      EnergyCost.from_base_unit(25),
    pool_fee_percent:      Percent.from_base_unit(0.07),
    facility_cost:         UsDollarRate.from_base_unit(73),
    other_cost:            UsDollarRate.from_base_unit(97),
    exchange_fee_percent:  Percent.from_base_unit(0.07),
    exchange_rate:         1,
    rig_utilization:       Percent.from_base_unit(0.50),
  }) }
  subject { described_class.new(data) }

  it_should_behave_like("CashFlow::Report data"){ subject { data } }
  it_should_behave_like("CashFlow::Report interface")

  its(:other_cost_value) { should == 97 * NumberWithUnits::HOURS_PER_MONTH }
  its(:other_cost_unit) { should == 'USD / month' }

  #TODO - tests are missing here.
end
