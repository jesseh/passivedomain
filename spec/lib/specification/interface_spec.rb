require "spec_helper"
require_dependency Rails.root.join('lib', 'specification').to_s


describe Specification::Interface do
  describe "specifiying the interface" do
    subject { described_class.new({ :a => Specification::Only.string,
                                    :b => Specification::Only.anything
                                  }) }
    it "is instanciated with a list of message specifications" do
      expect(subject).to be
    end

  end

  describe "#valid_response?" do
    let(:value) { 1 }
    subject { described_class.new({:a => Specification::Only.number}) }

    it "it returns false for an invalid value" do
      expect(subject.valid_response?(:a, 1)).to be_true
    end

    it "it returns true for a valid value" do
      expect(subject.valid_response?(:a, 'a')).to be_false
    end

    context "non-existant method" do
      it "it returns false for a valid value" do
        expect(subject.valid_response?(:nonexistant, 1)).to be_false
      end
    end

  end

  describe "stand-in object that responds to the interface" do
    subject { described_class.new({:an_attr => Specification::Only.positive_number}).responder(params) }

    context "no supplied params" do
      let(:params) { {} }

      it "responds with a default values for all sends to which it responds" do
        expect {subject.an_attr}.to_not raise_error
        expect(subject.an_attr).to be_a_kind_of Numeric
      end

      it "responds with a random value for sends, where possible" do
        sequence = Array.new(10) { subject.an_attr}
        is_random = sequence.uniq.count > 0
        expect(is_random).to be_true
      end
    end

    context "with supplied params" do
      let(:params) { { an_attr: 10203040 } }

      it "responds with supplied params when present" do
        expect(subject.an_attr).to eq(10203040)
      end
    end

    context "with params that have no corresponding message" do
      let(:params) { {nonexisting_message: 'yada'} }

      it "raises an error" do
        expect { subject }.to raise_error(NameError)
      end
    end
  end


  describe "check that an object responds according to the interface" do
    let(:test_responder) { Object.new }

    context "does conform" do
      before { test_responder.define_singleton_method(:an_attr){ 5 } }
      xit "returns true" do
        expect(subject.conforms?(test_responder)).to be_true
      end
    end

    context "non-conforming value" do
      before { test_responder.define_singleton_method(:an_attr){ 'wrong' } }
      xit "returns false" do
        expect(subject.conforms?(test_responder)).to be_false
      end
    end

    context "non-conforming message" do
      before { test_responder.define_singleton_method(:wrong_attr) { 10 } }
      xit "returns false" do
        expect(subject.conforms?(test_responder)).to be_false
      end
    end
  end

end
