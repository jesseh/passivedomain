require "spec_helper"

describe CashFlow::Report do
  let(:data) { double("Data", {
    electricity_rate:      EnergyCost.from_base_unit(25),
    exchange_fee_percent:  Percent.from_base_unit(0.07),
    exchange_rate:         1,
    facility_cost:         UsDollarRate.from_base_unit(73),
    mining_effort:         MiningEffort.from_base_unit(1E12),
    objective:             objective.freeze,
    other_cost:            UsDollarRate.from_base_unit(97),
    pool_fee_percent:      Percent.from_base_unit(0.50),
    reward_amount:         Bitcoin.from_base_unit(25),
    rig_hash_rate:         HashRate.from_base_unit(25),
    rig_utilization:       Percent.from_base_unit(0.50),
    watts_to_cool:         Power.from_base_unit(81),
    watts_to_mine:         Power.from_base_unit(33),
  }) }
  subject { CashFlow::Report.create(data) }
  describe ".create" do
    context "objective is acquisition" do
      let(:objective) { 'acquire' }
      it "should return an Acquire report" do
        expect(subject).to be_a_kind_of CashFlow::Reports::Acquire
      end
    end

    context "objective is retention" do
      let(:objective) { 'retain' }
      it "should return an Retain report" do
        expect(subject).to be_a_kind_of CashFlow::Reports::Retain
      end
    end

    context "objective is extraction" do
      let(:objective) { 'extract' }
      it "should return an Extract report" do
        expect(subject).to be_a_kind_of CashFlow::Reports::Extract
      end
    end

    context "data is invalie" do
      let(:objective) { 'non-existent' }
      it "should return an Empty report" do
        expect(subject).to be_a_kind_of CashFlow::Reports::Empty
      end
    end
  end
end
