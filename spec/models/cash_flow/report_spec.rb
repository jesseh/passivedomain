require "spec_helper"

describe CashFlow::Report do
  let(:objective) { '' }
  let (:data) { PassiveDomain::Interface.
                for_class(CashFlow::Reports::Acquire).responder({
                  objective: objective.freeze
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

    context "data is invalid" do
      let(:objective) { 'non-existent' }
      it "should return an Empty report" do
        expect(subject).to be_a_kind_of CashFlow::Reports::Empty
      end
    end
  end
end
