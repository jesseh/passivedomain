
shared_examples "a store" do

  let(:active_record_class){ double("active record class").as_null_object }
  let(:record){ double("Record").as_null_object }

  subject(:instance){ described_class.new(active_record_class) }

  describe ".build" do

    before do
      stub_const(active_record_class_name, double(active_record_class_name))
      allow( described_class ).to receive(:new)
    end

    subject!{ described_class.build }

    it { expect(described_class).to have_received(:new) }
  end

  describe "#find_all" do
    let(:results){ [double("Results").as_null_object] }

    before do
      allow(active_record_class).to receive(:all).and_return(results)
    end

    subject { instance.find_all }

    it { should eq(results) }
  end

  describe "#find_by_id" do
    before do
      allow(active_record_class).to receive(:find_by_id).and_return(record)
    end

    let(:model){ double("Model").as_null_object }
    let(:id){ '10' }

    subject! { instance.find_by_id id }

    it { should eq(record) }
    it { expect(active_record_class).to have_received(:find_by_id).with(id) }
  end

  describe "#find_by_name" do
    before do
      allow(active_record_class).to receive(:find_by_name).and_return(record)
    end

    let(:model){ double("Model").as_null_object }
    let(:name){ "Deep blue" }

    subject! { instance.find_by_name name  }

    it { should eq(record) }
    it { expect(active_record_class).to have_received(:find_by_name).with(name) }
  end

  describe "#create" do
    let(:valid){ true }
    let(:attributes){ {some: 'things'} }
    let(:model){ double("Model").as_null_object }
    let(:form){ double("Form", valid?: valid, attributes: attributes) }

    before do
      allow(active_record_class).to receive(:create!).and_return(record)
    end

    subject! { instance.create form }

    context "when form is valid" do
      it { should eq(record) }
      it { expect(active_record_class).to have_received(:create!).with(attributes) }
    end

    context "when form is invalid" do
      let(:valid){ false }
      it { expect(active_record_class).to_not have_received(:create!) }
      it { should equal(form) }
    end

  end

end
