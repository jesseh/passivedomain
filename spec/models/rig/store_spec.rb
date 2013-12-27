require "spec_helper"

describe Rig::Store do

  before do
    stub_const('Rig::Model', double('Rig::Model'))
  end

  describe ".find_all" do
    let(:results){ double("Results") }

    before do
      allow(Rig::Model).to receive(:all).and_return(results)
    end

    subject { described_class.find_all }

    it { should eql(results) }
  end

  describe ".find_by_id" do
    before do
      allow(Rig::Model).to receive(:find_by_id).and_return(model)
    end

    let(:model){ double("Model") }
    let(:id){ '10' }

    subject! { described_class.find_by_id id }

    it { should eql(model) }
    it { expect(Rig::Model).to have_received(:find_by_id).with(id) }
  end

end
