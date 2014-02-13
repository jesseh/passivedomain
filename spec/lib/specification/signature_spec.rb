require 'spec_helper'
require_dependency Rails.root.join('lib', 'specification').to_s

describe Specification::Signature do
  subject { described_class.new(:a_method, 
                                [Specification::Only.string, Specification::Only.number],
                                Specification::Only.symbol
                               ) }
  
  describe "instantiating with a list of argument requirements, and a return value requirement" do

    its(:method) { should eq(:a_method) }
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

  describe "#sample_response" do
    let(:only) { double(:only, :standin_value => :response_from_only) }

    subject { described_class.new(:a_method, [], only) }

    it "delegates to the response only object" do
      expect(subject.sample_response).to eq :response_from_only
    end
  end

end


