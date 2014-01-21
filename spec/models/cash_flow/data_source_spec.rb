require "spec_helper"

describe CashFlow::DataSource do
  let(:mapper_class) { Class.new }
  let(:instance){ described_class.new(mapper_class) }

  subject { instance }

  describe "#canned" do
    before { mapper_class.stub(:new => :mapper_sentinal) }

    subject!{ instance.canned }
    it { should eq(:mapper_sentinal) }
    it { expect(mapper_class).to have_received(:new).with(anything) }
  end

end
