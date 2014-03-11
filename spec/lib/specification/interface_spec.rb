require "spec_helper"
require_dependency Rails.root.join('lib', 'specification').to_s
require_dependency Rails.root.join('lib', 'specification', 'signatures', 'query').to_s


describe Specification::Interface do
  describe "specifiying the interface" do
    let(:specs) { [ Specification::Signatures::Query.new(:a, [], Specification::Only.string),
                    Specification::Signatures::Query.new(:b, [], Specification::Only.anything)
                  ] }
    subject { described_class.new(specs) }

    it "is instanciated with a list of method specifications" do
      expect(subject).to be
    end

    context "multiple signagures for one method" do
      subject { described_class.new([ Specification::Signatures::Query.new(:a, [], Specification::Only.string),
                                      Specification::Signatures::Query.new(:a, [], Specification::Only.anything)
                                    ]) }

      it "should raise an error" do
        expect{ subject }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#valid_response?" do
    let(:value) { 1 }
    subject { described_class.new([Specification::Signatures::Query.new(:a, [], Specification::Only.number) ]) }

    it "it returns false for an invalid value" do
      expect(subject.valid_response?(:a, 'a')).to be_false
    end

    it "it returns true for a valid value" do
      expect(subject.valid_response?(:a, 1)).to be_true
    end

    context "non-existant method symbol" do
      it "it returns false for a valid value" do
        expect(subject.valid_response?(:nonexistant, 1)).to be_false
      end
    end
  end

  describe "#valid_method_name?" do
    subject { described_class.new([Specification::Signatures::Query.new(:a, [], Specification::Only.number) ]) }

    it "it returns false for an invalid method" do
      expect(subject.valid_method_name?(:a)).to be_true
    end

    it "it returns true for a valid method" do
      expect(subject.valid_method_name?(:nope)).to be_false
    end
  end

  describe "#valid_send?" do
    let(:target) { Object.new }
    let(:signature) { Specification::Signatures::Query.new(:a, [Specification::Only.string], Specification::Only.number) }
    subject { described_class.new([ signature ]) }

    it "is true for a valid send" do
      target.define_singleton_method(:a){ |some_string| 5 }
      expect(subject.valid_send?(target, :a, ['an arg'])).to be_true
    end

    it "is false when the method is missing" do
      expect(subject.valid_send?(target, :a, ['an arg'])).to be_false
    end

    it "is false when the method exists, but is not in the spec" do
      target.define_singleton_method(:b){ |some_string| 5 }
      expect(subject.valid_send?(target, :b, ['an arg'])).to be_false
    end

    it "is false when args are wrong" do
      target.define_singleton_method(:a){ |some_string| 5 }
      expect(subject.valid_send?(target, :a, [2])).to be_false
    end

    it "is false when args are wrong" do
      target.define_singleton_method(:a){ |some_string| 5 }
      expect(subject.valid_send?(target, :a, [2])).to be_false
    end

    it "is false when the return value is wrong" do
      target.define_singleton_method(:a){ |some_string| 'wrong return value' }
      expect(subject.valid_send?(target, :a, ['an arg'])).to be_false
    end

    context "method not idempotent" do
      let(:signature) { Specification::Signatures::Command.new(:a, []) }

      it "does not check return value" do
        target.instance_eval do
          @checked = false
          def a(some_string); @checked = true; end
          def checked?; @checked; end
        end
        subject.valid_send?(target, :a, [])
        expect(target.checked?).to be_false
      end
    end
  end

  describe "stand-in object that responds to the interface" do
    subject { specification = described_class.new([Specification::Signatures::Query.new(:an_attr, [], Specification::Only.number) ])
              specification.responder(params) }

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

    context "with params that have no corresponding method" do
      let(:params) { {nonexisting_method: 'yada'} }

      it "raises an error" do
        expect { subject }.to raise_error(KeyError)
      end
    end
  end


  describe "check that an object responds according to the interface" do

    let(:instance) { described_class.new([Specification::Signatures::Query.new(:an_attr, [], Specification::Only.number) ]) }
    let(:test_responder) { Object.new }
    subject { instance.conforms?(test_responder) }

    context "does conform" do
      before { test_responder.define_singleton_method(:an_attr){ 5 } }
      it { should be_true }
    end

    context "non-conforming return value" do
      before { test_responder.define_singleton_method(:an_attr){ 'wrong' } }
      it { should be_false }
    end

    context "non-conforming method" do
      before { test_responder.define_singleton_method(:wrong_attr) { 10 } }
      it { should be_false }
    end
  end

  describe "#method_symbols" do
    let(:value) { 1 }
    subject { described_class.new([
                                  Specification::Signatures::Query.new(:a, [], Specification::Only.number),
                                  Specification::Signatures::Query.new(:b, [], Specification::Only.number),
    ]) }
    it "is a list of symbols" do
      expect(subject.method_symbols).to match_array([:a, :b])
    end
  end
end
