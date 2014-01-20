require "spec_helper"

describe CashFlow::DataSource do
  let(:mapper_class) { Class.new }

  before { mapper_class.stub(:produce => :mapper_sentinal) }

  subject { described_class.new(mapper_class) }


  it "creates a new mapper initialized with data" do
    subject.canned
    expect(mapper_class).to have_received(:produce).with(anything)
  end

  it "returns the new mapper" do
    expect(subject.canned).to eq(:mapper_sentinal)
  end
end
