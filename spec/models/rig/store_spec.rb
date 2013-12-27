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

  describe ".find_by_name" do
    before do
      allow(Rig::Model).to receive(:find_by_name).and_return(model)
    end

    let(:model){ double("Model") }
    let(:name){ "Deep blue" }

    subject! { described_class.find_by_name name  }

    it { should eql(model) }
    it { expect(Rig::Model).to have_received(:find_by_name).with(name) }
  end

  describe ".create" do
    let(:valid){ true }
    let(:attributes){ {some: 'things'} }
    let(:model){ double("Model") }
    let(:form){ double("Form", valid?: valid, attributes: attributes) }

    before do
      allow(Rig::Model).to receive(:create!).and_return(model)
    end

    subject! { described_class.create form }

    context "when form is valid" do
      it { expect(Rig::Model).to have_received(:create!).with(attributes) }
      it { should equal(model) }
    end

    context "when form is invalid" do
      let(:valid){ false }
      it { expect(Rig::Model).to_not have_received(:create!) }
      it { should equal(form) }
    end

  end

end
