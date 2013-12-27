require "spec_helper"

describe Rig::Store do

  let(:active_record_class){ double("active record class") }

  subject(:instance){ described_class.new active_record_class }

  describe ".build" do
    before do
      stub_const('Rig::Model', double('Rig::Model'))
      allow( described_class ).to receive(:new)
    end

    subject!{ described_class.build }

    it { expect(described_class).to have_received(:new).with(Rig::Model)}
  end

  describe "#find_all" do
    let(:results){ double("Results") }

    before do
      allow(active_record_class).to receive(:all).and_return(results)
    end

    subject { instance.find_all }

    it { should eql(results) }
  end

  describe "#find_by_id" do
    before do
      allow(active_record_class).to receive(:find_by_id).and_return(model)
    end

    let(:model){ double("Model") }
    let(:id){ '10' }

    subject! { instance.find_by_id id }

    it { should eql(model) }
    it { expect(active_record_class).to have_received(:find_by_id).with(id) }
  end

  describe "#find_by_name" do
    before do
      allow(active_record_class).to receive(:find_by_name).and_return(model)
    end

    let(:model){ double("Model") }
    let(:name){ "Deep blue" }

    subject! { instance.find_by_name name  }

    it { should eql(model) }
    it { expect(active_record_class).to have_received(:find_by_name).with(name) }
  end

  describe "#create" do
    let(:valid){ true }
    let(:attributes){ {some: 'things'} }
    let(:model){ double("Model") }
    let(:form){ double("Form", valid?: valid, attributes: attributes) }

    before do
      allow(active_record_class).to receive(:create!).and_return(model)
    end

    subject! { instance.create form }

    context "when form is valid" do
      it { expect(active_record_class).to have_received(:create!).with(attributes) }
      it { should equal(model) }
    end

    context "when form is invalid" do
      let(:valid){ false }
      it { expect(active_record_class).to_not have_received(:create!) }
      it { should equal(form) }
    end

  end

end
