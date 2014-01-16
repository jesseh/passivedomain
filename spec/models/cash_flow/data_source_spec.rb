require "spec_helper"

describe CashFlow::DataSource do
  let(:mapper) { double("mapper").as_null_object }

  subject { described_class.new(mapper) }

  describe "canned data" do
    before { subject.canned }
    it { expect(mapper).to have_received(:initialize_attrs).with(anything) }
  end
end
