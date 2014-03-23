require 'spec_helper'
require_dependency Rails.root.join('lib', 'specification', 'interface_dsl').to_s
require_dependency Rails.root.join('lib', 'specification', 'interface').to_s

describe Specification::InterfaceDSL do
  it 'builds an interface' do
    expect(subject.build).to be_instance_of Specification::Interface
  end

  describe "#queries" do
    subject do
      described_class.new do
        querying(:cool?).with(a.string, a.string => :optional).returns a.number
        querying(:a_query).returns a.number
      end
    end

    it "collects queries" do
      expect(subject.build.valid_method?(:a_query)).to be_true
    end
  end

end
