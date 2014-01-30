require "spec_helper"

require_dependency Rails.root.join('lib', 'passive_domain', 'interface').to_s
require_dependency Rails.root.join('lib', 'passive_domain').to_s

describe CashFlow::Mapper do

  let(:interface){ PassiveDomain::Interface.new(described_class) }
  let (:record) { interface.responder(record_data) }
  let(:record_data){ {} }

  subject { described_class.new(record) }

  it_behaves_like('value object')
  it_behaves_like('CashFlow::Report data')

  describe "#objective" do
    let(:record_data){ { objective: 'yada' } }
    it { expect( subject.objective ).to eql('yada'.freeze) }
  end

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
    it { expect( subject.facility_cost ).to eql(UsDollarRate.from_base_unit(BigDecimal(30.00,9) / NumberWithUnits::HOURS_PER_MONTH)) }
  end

  describe "#other_cost" do
    let(:record_data){ {other_cost_fractional: 30_00} }
    it { expect( subject.other_cost ).to eql(UsDollarRate.from_base_unit(BigDecimal(30.00,9) / NumberWithUnits::HOURS_PER_MONTH)) }
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
