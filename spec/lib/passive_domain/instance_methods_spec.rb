require 'spec_helper'
require_dependency Rails.root.join('lib', 'passive_domain').to_s

describe PassiveDomain::InstanceMethods do
  let(:cls) { Class.new do
    extend PassiveDomain 

    value_object_initializer do
      value
    end
  end } 

  describe "#new / #initialize" do
    it "accepts 1 arg" do
      expect { cls.new(:an_arg) }.to_not raise_error
    end

  end
end
