require 'spec_helper'
require_dependency Rails.root.join('lib', 'specification').to_s

describe Specification::Message do

  describe "without a message symbol" do
    subject { described_class.new }


    it "exists" do
      expect(subject).to be
    end
  end

  describe "with a message symbol" do
    subject { described_class.new(:a_message) }


    it "exists" do
      expect(subject).to be
    end
  end

  describe "with an optional must_be requirement" do
    subject { described_class.new(:a_message, Specification::Only.number) }

    it "exists" do
      expect(subject).to be
    end
  end

  describe "with an optional 'when_missing' value" do
    subject { described_class.new(:a_message, Specification::Only.string, 'the_default_value') }

    it "exists" do
      expect(subject).to be
    end
  end
end
