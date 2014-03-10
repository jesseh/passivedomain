require "spec_helper"

require_dependency Rails.root.join('lib', 'specification').to_s


describe Specification::Only do
  subject { described_class.positive_number }

  it_behaves_like('value object')

  describe "Class constructors" do
    subject { described_class.send(method_symbol) }

    let(:v2_of_subject) { described_class.send(method_symbol) }

    context "anything" do
      let(:method_symbol) { :anything }
      it "does equality correctly" do
        expect(subject).to eq v2_of_subject
      end
    end

    context "instance_of" do
      subject { described_class.send(method_symbol, Class) }
      let(:method_symbol) { :instance_of }

      context "equality" do
        let(:v2_of_subject) { described_class.send(method_symbol, Class) }
        let(:different_than_subject) { described_class.send(method_symbol, Numeric) }

        it { expect(subject).to eq v2_of_subject }
        it { expect(subject).to_not eq different_than_subject }
      end
    end

    context "interface" do
      let(:method_symbol) { :interface }

      let(:interface_1) { Specification::Interface.new([Specification::Signatures::Query.new(:a) ]) }
      let(:interface_2) { Specification::Interface.new([]) }
      let(:test_object) { Object.new }

      subject { described_class.send(method_symbol, interface_1) }


      context "equality" do
        let(:v2_of_subject) { described_class.send(method_symbol, interface_1) }
        let(:different_than_subject) { described_class.send(method_symbol, interface_2) }
        it { expect(subject).to eq v2_of_subject }
      end

      context "valid object" do
        before { test_object.define_singleton_method(:a) { } }

        it { expect(subject.valid?(test_object)).to be_true }
      end

      context "invalid input" do
        it { expect(subject.valid?(test_object)).to be_false }
      end
    end

    context "number" do
      let(:method_symbol) { :number }
      it "does equality correctly" do
        expect(subject).to eq v2_of_subject
      end
    end

    context "equal_to" do
      subject { described_class.send(method_symbol, 1) }
      let(:v2_of_subject) { described_class.send(method_symbol, 1) }
      let(:different_than_subject) { described_class.send(method_symbol, 2) }
      let(:method_symbol) { :equal_to }
      it "does equality correctly" do
        expect(subject).to eq v2_of_subject
      end
      it "does inequality correctly" do
        expect(subject).to_not eq different_than_subject
      end
    end

    context "string" do
      let(:method_symbol) { :string }
      it "does equality correctly" do
        expect(subject).to eq v2_of_subject
      end
    end

    context "nil" do
      let(:method_symbol) { :nil_value }
      it "does equality correctly" do
        expect(subject).to eq v2_of_subject
      end
    end

    context "positive_integer" do
      let(:method_symbol) { :positive_integer }
      it "does equality correctly" do
        expect(subject).to eq v2_of_subject
      end
    end

   context "positive_number" do
      let(:method_symbol) { :positive_number }
      it "does equality correctly" do
        expect(subject).to eq v2_of_subject
      end
    end

    context "number_within" do
      subject { described_class.send(method_symbol, 1...4) }
      let(:v2_of_subject) { described_class.send(method_symbol, 1...4) }
      let(:different_than_subject) { described_class.send(method_symbol, 2...4) }
      let(:method_symbol) { :number_within }
      it "does equality correctly" do
        expect(subject).to eq v2_of_subject
      end
      it "does inequality correctly" do
        expect(subject).to_not eq different_than_subject
      end
    end

    context "instance_array" do
      let(:cls) { Class.new }
      let(:v2_of_subject) { described_class.send(method_symbol, cls) }
      let(:different_than_subject) { described_class.send(method_symbol, Class.new) }
      let(:method_symbol) { :instance_array }

      subject { described_class.send(method_symbol, cls) }

      it "does equality correctly" do
        expect(subject).to eq v2_of_subject
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
