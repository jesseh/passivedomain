shared_examples "PassiveDomain interface" do

  describe ".value_object_initializer" do
    subject { described_class }
    it { should respond_to(:value_object_initializer)}
  end

end

shared_examples "PassiveDomain instance interface" do

  describe "#inputs" do
    it { should respond_to(:input_sources) }
  end

end
