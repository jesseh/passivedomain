require 'spec_helper'
require_dependency Rails.root.join('lib', 'specification').to_s

describe Specification::Signature do
  subject { described_class.new(:a_method, 
                                [Specification::Only.string, Specification::Only.number],
                                Specification::Only.symbol
                               ) }
  
  describe "instantiating with a list of argument requirements, and a return value requirement" do

    its(:method_symbol) { should eq(:a_method) }
    its(:arguments) { should eq([Specification::Only.string, Specification::Only.number]) }
    its(:response) { should eq(Specification::Only.symbol) }

  end
    
  describe "#valid_response?" do
    let(:only) { double(:only, :valid? => :response_from_only) }

    subject { described_class.new(:a_method, [], only) }

    it "delegates to the response only object" do
      expect(subject.valid_response?('yada')).to eq :response_from_only
    end
  end

  describe "#valid_arguments?" do
    let(:only_arg1) { double(:only_arg1, :valid? => true) }
    let(:only_arg2) { double(:only_arg2, :valid? => true) }
    let(:only_rv) { double(:only_rv, :valid? => true) }

    subject { described_class.new(:a_method, [only_arg1, only_arg2], only_rv) }

    context "all arguments are valid" do
      it "is true" do
        expect(subject.valid_arguments?(['a', 'b'])).to be_true
      end
    end

    context "insufficient arguments" do
      it "is false" do
        expect(subject.valid_arguments?(['a'])).to be_false
      end
    end

    context "too many arguments" do
      it "is false" do
        expect(subject.valid_arguments?(['a', 'b', 'c'])).to be_false
      end
    end

    context "invalid argument" do
      let(:only_arg1) { double(:only_arg1, :valid? => false) }
      it "is false" do
        expect(subject.valid_arguments?(['invalid', 'b'])).to be_false
      end
    end


  end

  describe "#sample_response" do
    let(:only) { double(:only, :standin_value => :response_from_only) }

    subject { described_class.new(:a_method, [], only) }

    it "delegates to the response only object" do
      expect(subject.sample_response).to eq :response_from_only
    end
  end

end


