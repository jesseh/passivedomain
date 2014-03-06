require 'spec_helper'
require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'specification').to_s
require_dependency Rails.root.join('lib', 'specification', 'signatures', 'query').to_s

describe PassiveDomain::InstanceMethods do
  context "using passive domain interface" do
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
      expect(subject.inputs[0].target).to eq(:bar)
    end

    it "has a list of input_targets" do
      expect(subject.input_targets).to match_array([:bar])
    end
  end

  context "using specification interface" do
    subject { Class.new do
      extend PassiveDomain

      value_object_initializer(
        Specification::Interface.new(
          [ Specification::Signatures::Query.new(:foo, [], Specification::Only.anything ) ]
        )
      )
        
      def bar
        @foo
      end
    end }

    describe ".stand_in" do
      it "is an instance of the source class" do
        expect(subject.stand_in).to be_instance_of(subject)
      end
    end

    it "has an interface" do
      expect(subject.interface).to be
    end

  end
end
