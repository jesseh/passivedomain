require "spec_helper"

describe CashFlow::Mapper do

  HOURS_PER_MONTH = 730


  let(:record){ double("Record", record_default.merge(record_data)) }
  let(:record_default) { { 
    rig_hash_rate:         25,
    watts_to_mine:         33,
    watts_to_cool:         81,
    mining_difficulty:     123456,
    reward_amount_fractional: 25,
    electricity_rate_fractional: 12,
    pool_fee_percent:      0.12,
    facility_cost_fractional: 73,
    other_cost_fractional: 97,
    exchange_fee_percent:  0.07,
    exchange_rate:         1,
    rig_utilization:       0.50,
  } }
  let(:record_data){ {} }

  subject { described_class.new.initialize_attrs(record) }

  it_behaves_like 'value object'

  describe "#rig_hash_rate" do
    let(:record_data){ { rig_hash_rate: 123 } }
    it { expect( subject.rig_hash_rate ).to eql(HashRate.from_base_unit(123)) }
  end

  describe "#electricity_rate" do
    let(:record_data){ { electricity_rate_fractional: 19 } }
    it { expect( subject.electricity_rate ).to eql(EnergyCost.from_base_unit(0.19)) }
  end

  describe "#facility_cost" do
    let(:record_data){ {facility_cost_fractional: 30_00} }
    it { expect( subject.facility_cost ).to eql(UsDollarRate.from_base_unit(30.00 / HOURS_PER_MONTH)) }
  end
  
  describe "#other_cost" do
    let(:record_data){ {other_cost_fractional: 30_00} }
    it { expect( subject.other_cost ).to eql(UsDollarRate.from_base_unit(30.00 / HOURS_PER_MONTH)) }
  end

  describe "#reward_amount" do
    let(:record_data){ {reward_amount_fractional: 30} }
    it { expect( subject.reward_amount ).to eql(Bitcoin.from_base_unit(30)) }
  end

  describe "#mining_effort" do
    let(:record_data){ {mining_difficulty: 100} }
    it { expect( subject.mining_effort ).to eql(MiningEffort.from_base_unit(429503283300.0)) }
  end
end
