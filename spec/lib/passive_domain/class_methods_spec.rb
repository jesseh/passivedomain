require 'spec_helper'
require_dependency Rails.root.join('lib', 'passive_domain').to_s

describe PassiveDomain::InstanceMethods do
  subject { Class.new do
    extend PassiveDomain

    value_object_initializer do
      value(:foo => :bar)
    end
  end }

  describe ".stand_in" do
    it "is an instance of the source class" do
      expect(subject.stand_in).to be_instance_of(subject)
    end
  end

  it "has a list of inputs" do
    expect(subject.inputs[0].source).to eq(:foo)
    expect(subject.inputs[0].target).to eq("bar")
  end

  it "has a list of input_targets" do
    expect(subject.input_targets).to match_array(["bar"])
  end
end
