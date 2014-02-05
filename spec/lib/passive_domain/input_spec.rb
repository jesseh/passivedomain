require 'spec_helper'
require_dependency Rails.root.join('lib', 'passive_domain').to_s

describe PassiveDomain::Input do
  subject { described_class.new(:yada => :yo) }

  describe ".new" do
    it "has a source and a target symbol" do
      expect(subject.source).to eq(:yada)
      expect(subject.target).to eq(:yo)
    end

    context "no target" do
      subject { described_class.new(:yada) }
      it "has a target that is the source" do
        expect(subject.target).to eq(:yada)
      end
    end
  end

  describe "#when_missing" do
    subject { described_class.new(:a_method) }
    context "without when_missing" do
      it "raises an error when the data object is missing the source method" do
        expect{subject.value(Object.new)}.to raise_error(NoMethodError)
      end
    end

    context "with when_missing" do
      before { subject.when_missing(:sentinel) }
      it "uses the given value when the data object is missing the source method" do
        expect(subject.value(Object.new)).to eq(:sentinel)
      end
    end
  end

  describe "#freeze_it" do
    subject { described_class.new(:a_method).freeze_it }

    it "freezes the value.." do
        expect(subject.value(double('source', :a_method => 'unfrozen'))).to be_frozen
    end
  end



  describe "#value" do
    subject { described_class.new(:a_method) }

    context "simplest possible instance" do
      its "value raises an error" do
        expect{ subject.value }.to raise_error
      end
    end

  end
end
