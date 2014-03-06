require 'spec_helper'
require_dependency Rails.root.join('lib', 'specification').to_s

shared_examples "a signature" do
  describe "instantiating" do
    context "with a list of argument requirements, and a return value requirement" do
      subject { described_class.new(:a_method, 
                                  [Specification::Only.string, Specification::Only.number],
                                  Specification::Only.symbol
                                 ) }

      its(:method_symbol) { should eq(:a_method) }
      its(:arguments) { should eq([Specification::Only.string, Specification::Only.number]) }
      its(:response) { should eq(Specification::Only.symbol) }
    end

    context "with no return value" do
      subject { described_class.new(:a_method, []) }

      its(:method_symbol) { should eq(:a_method) }
      its(:arguments) { should eq([]) }
      its(:response) { should eq(nil) }
    end

    context "with arguments nor return value" do
      subject { described_class.new(:a_method) }

      its(:method_symbol) { should eq(:a_method) }
      its(:arguments) { should eq([]) }
      its(:response) { should eq(nil) }
    end

  end
    
  describe "#response_defined?" do
    it "is true when defined" do
      instance = described_class.new(:a_method, [], double(:rv_only))
      expect(instance.response_defined?).to be_true
    end

    it "is false when not defined" do
      instance = described_class.new(:a_method, [])
      expect(instance.response_defined?).to be_false
    end
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

  describe "#standin_arguments" do
    let(:only_1) { double(:only_1, :standin_value => :arg_1) }
    let(:only_2) { double(:only_2, :standin_value => :arg_2) }

    subject { described_class.new(:a_method, [only_1, only_2]) }

    it "generates standin arguments based on the only requirements" do
      expect(subject.standin_arguments).to eq [:arg_1, :arg_2] 
    end
  end
end

