require 'spec_helper'

describe Form::Builder do

  describe ".new" do
    let(:mapper_input_sources){ [] }
    let(:mapper){ double("mapper", :input_sources => mapper_input_sources) }
    let(:block){ ->(builder){} }
    subject { described_class.new(mapper,&block) }

    context "the double" do
      subject { mapper }
      it_should_behave_like "PassiveDomain instance interface"
    end

    context "creation" do
      it { expect{|b| described_class.new(mapper,&b) }.to yield_control }
    end

    context "with inputs that are unused" do
      let(:mapper_input_sources){ [:fred] }
      it { expect{ subject }.to raise_error("Unused inputs fred") }
    end

    context "with inputs that are all used" do
      let(:block){
        ->(builder){ builder.input :fred }
      }
      let(:mapper_input_sources){ [:fred] }
      it { expect{ subject }.to_not raise_error }
    end
  end

end
