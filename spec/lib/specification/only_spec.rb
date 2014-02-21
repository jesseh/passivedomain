require "spec_helper"

require_dependency Rails.root.join('lib', 'specification').to_s


describe Specification::Only do
  subject { described_class.positive_number }

  it_behaves_like('value object')

  describe "Class constructors" do
    let(:v1) { described_class.send(method_symbol) }
    let(:v2) { described_class.send(method_symbol) }
    subject { described_class.positive_number }

    context "anything" do
      let(:method_symbol) { :anything }
      it "does equality correctly" do
        expect(v1).to eq v2
      end
    end

    context "instance_of" do
      let(:v1) { described_class.send(method_symbol, Class) }
      let(:v2) { described_class.send(method_symbol, Class) }
      let(:v3) { described_class.send(method_symbol, Numeric) }
      let(:method_symbol) { :instance_of }
      it "does equality correctly" do
        expect(v1).to eq v2
      end
      it "does inequality correctly" do
        expect(v1).to_not eq v3
      end
    end

    context "number" do
      let(:method_symbol) { :number }
      it "does equality correctly" do
        expect(v1).to eq v2
      end
    end

    context "equal_to" do
      let(:v1) { described_class.send(method_symbol, 1) }
      let(:v2) { described_class.send(method_symbol, 1) }
      let(:v3) { described_class.send(method_symbol, 2) }
      let(:method_symbol) { :equal_to }
      it "does equality correctly" do
        expect(v1).to eq v2
      end
      it "does inequality correctly" do
        expect(v1).to_not eq v3
      end
    end

    context "string" do
      let(:method_symbol) { :string }
      it "does equality correctly" do
        expect(v1).to eq v2
      end
    end

    context "nil" do
      let(:method_symbol) { :nil_value }
      it "does equality correctly" do
        expect(v1).to eq v2
      end
    end

    context "positive_integer" do
      let(:method_symbol) { :positive_integer }
      it "does equality correctly" do
        expect(v1).to eq v2
      end
    end

   context "positive_number" do
      let(:method_symbol) { :positive_number }
      it "does equality correctly" do
        expect(v1).to eq v2
      end
    end

    context "number_within" do
      let(:v1) { described_class.send(method_symbol, 1...4) }
      let(:v2) { described_class.send(method_symbol, 1...4) }
      let(:v3) { described_class.send(method_symbol, 2...4) }
      let(:method_symbol) { :number_within }
      it "does equality correctly" do
        expect(v1).to eq v2
      end
      it "does inequality correctly" do
        expect(v1).to_not eq v3
      end
    end

    context "instance_array" do
      let(:cls) { Class.new }
      let(:v2) { described_class.send(method_symbol, cls) }
      let(:v3) { described_class.send(method_symbol, Class.new) }
      let(:method_symbol) { :instance_array }

      subject { described_class.send(method_symbol, cls) }

      it "does equality correctly" do
        expect(subject).to eq v2
      end

      context "valid input" do
        it "checks the class of the instances in the array" do
          expect(subject.valid?([cls.new, cls.new])).to be_true
        end
      end

      context "invalid input" do
        it "checks the class of the instances in the array" do
          expect(subject.valid?([1,2,3])).to be_false
        end
      end
    end

  end
end