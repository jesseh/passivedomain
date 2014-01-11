require "spec_helper"
require_dependency 'numbers_with_units'

describe CashFlow::Mapper do
  include NumbersWithUnits

  let(:record) { double("Record") }
  let(:instance) { described_class.new(record) }

  describe "#rig"
  
  describe "#rig_hash_rate" do
    let(:record){ double("Record",
      rig_hash_rate: 123
    )}
    subject! { instance.rig_hash_rate }
    it{ should eql(hash_rate.hash_per_second(123)) }
  end

  describe "#electricity_rate" do
    let(:record){ double("Record", electricity_rate_fractional: 19 )}
    subject! { instance.electricity_rate }
    it{ should eql(energy_cost.us_cents_per_kwh(19)) }
  end

  describe "#facility_cost" do
    let(:record){ double("Record", facility_cost_fractional: 30_00 )}
    subject! { instance.facility_cost }
    it{ should eql(us_dollar_rate.per_month(30_00)) }
  end
  
  describe "#other_cost" do
    let(:record){ double("Record", other_cost_fractional: 30_00 )}
    subject! { instance.other_cost }
    it{ should eql(us_dollar_rate.per_month(30_00)) }
  end

  describe "#reward_amount" do
    let(:record){ double("Record",
      reward_amount_fractional: 30_00
    )}
    subject! { instance.reward_amount }
    it{ should eql(reward_rate.bitcoin_per_block(30_00)) }
  end

  describe "a_delegated_method" do
    let(:record) { double("Record", a_delegated_method: "was found") }
    subject! { instance.a_delegated_method }
    it{ should eql("was found") }
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
