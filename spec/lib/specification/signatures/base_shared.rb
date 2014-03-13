require 'spec_helper'
require_dependency Rails.root.join('lib', 'specification').to_s

shared_examples "a signature" do
  it("has a method symbol")          { expect(subject.method_symbol).to be }
  it("responds to response_defined?"){ expect { subject.response_defined? }.to_not raise_error }
  it("responds to valid_response?")  { expect { subject.valid_response?('yada') }.to_not raise_error }
  it("responds to valid_arguments?") { expect { subject.valid_arguments?([1,2]) }.to_not raise_error }
  it("responds to standin_arguments"){ expect { subject.standin_arguments }.to_not raise_error }
  it("idempotent?")                  { expect { subject.idempotent? }.to_not raise_error }
end

shared_examples "an instance method signature" do
  it_behaves_like "a signature"

  describe "instantiating" do
    context "with a list of argument requirements, and a return value requirement" do
      subject { described_class.new(:a_method, 
                                  [Specification::Only.string, Specification::Only.number],
                                  Specification::Only.symbol,
                                  1
                                 ) }

      its(:method_symbol) { should eq(:a_method) }
    end

    context "valid arguments" do
      it("just a method symbol")    { expect { described_class.new(:a) }.to_not raise_error }
      it("with args")               { expect { described_class.new(:a, []) }.to_not raise_error }
      it("with return value")       { expect { described_class.new(:a, [], double(:only)) }.to_not raise_error }
      it("with optional args count"){ expect { described_class.new(:a, [double(:arg)], double(:only), 1) }.to_not raise_error }
    end

    context "invalid arguments" do
      it("with optional args count"){ expect { described_class.new(:a, [], nil, 1) }.to raise_error }
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
    context "undefined response" do
      subject { described_class.new(:a_method, []) }

      it "is true" do
        expect(subject.valid_response?('yada')).to be_true
      end
    end

    context "defined response" do
      let(:only) { double(:only, :valid? => :response_from_only) }

      subject { described_class.new(:a_method, [], only) }

      it "delegates to the response only object" do
        expect(subject.valid_response?('yada')).to eq :response_from_only
      end
    end
  end

  describe "#valid_arguments?" do
    let(:only_arg1) { double(:only_arg1, :valid? => true) }
    let(:only_arg2) { double(:only_arg2, :valid? => true) }
    let(:only_arg3) { double(:only_arg3, :valid? => true) }
    let(:only_rv) { double(:only_rv, :valid? => true) }

    subject { described_class.new(:a_method, [only_arg1, only_arg2, only_arg3], only_rv, 1) }

    context "correct arguments" do
      it "required and optional supplied" do
        expect(subject.valid_arguments?(['a', 'b', 'c'])).to be_true
      end
      it "only required supplied" do
        expect(subject.valid_arguments?(['a', 'b'])).to be_true
      end
      it "insufficient supplied" do
        expect(subject.valid_arguments?(['a'])).to be_false
      end
      it "too many supplied" do
        expect(subject.valid_arguments?(['a', 'b', 'c', 'd'])).to be_false
      end
    end

    context "with no arguments initialized" do
      subject { described_class.new(:a_method) }
      it "checks the arguments" do
        expect(subject.valid_arguments?([])).to be_true
        expect(subject.valid_arguments?(['a'])).to be_false
      end
    end

    context "invalid argument" do
      let(:only_arg1) { double(:only_arg1, :valid? => false) }
      it("is false") { expect(subject.valid_arguments?(['invalid', 'b'])).to be_false }
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

  describe "#idempotent?" do
    it "should be declared" do
      expect { subject.idempotent? }.not_to raise_error
    end
  end
end

