require "spec_helper"

describe CashFlow::Mapper do

  HOURS_PER_MONTH = 730

  let(:record) { double("Record") }
  let(:instance) { described_class.new(record) }

  describe "#rig"
  
  describe "#rig_hash_rate" do
    let(:record){ double("Record", rig_hash_rate: 123)}
    it { expect( instance.rig_hash_rate ).to eql(HashRate.from_base_unit(123)) }
  end

  describe "#electricity_rate" do
    let(:record){ double("Record", electricity_rate_fractional: 19 )}
    it { expect( instance.electricity_rate ).to eql(EnergyCost.from_base_unit(0.19)) }
  end

  describe "#facility_cost" do
    let(:record){ double("Record", facility_cost_fractional: 30_00 )}
    it { expect( instance.facility_cost ).to eql(UsDollarRate.from_base_unit(30.00 / HOURS_PER_MONTH)) }
  end
  
  describe "#other_cost" do
    let(:record){ double("Record", other_cost_fractional: 30_00 )}
    it { expect( instance.other_cost ).to eql(UsDollarRate.from_base_unit(30.00 / HOURS_PER_MONTH)) }
  end

  describe "#reward_amount" do
    let(:record){ double("Record", reward_amount_fractional: 30)}
    it { expect( instance.reward_amount ).to eql(Bitcoin.from_base_unit(30)) }
  end

  describe "#mining_effort" do
    let(:record){ double("Record", mining_difficulty: 100)}
    it { expect( instance.mining_effort ).to eql(MiningEffort.from_base_unit(429503283300.0)) }
  end

  describe "a_delegated_method" do
    let(:record) { double("Record", a_delegated_method: "was found") }
    it { expect( instance.a_delegated_method ).to eql("was found") }
  end

  describe "#respond_to?" do
    let(:record) { double("Record", a_delegated_method: "exists") }
    
    context "for method present on the record" do
      subject { instance.respond_to? :a_delegated_method }
      it{ should be_true }
    end

    context "for non existing method" do
      subject { instance.respond_to? :nonsense }
      it{ should be_false }
    end
  end

end
