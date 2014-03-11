require 'spec_helper'
require_dependency Rails.root.join('lib', 'specification', 'signatures', 'query').to_s
require_dependency Rails.root.join('spec', 'lib', 'specification', 'signatures', 'base_shared').to_s

describe Specification::Signatures::Query do
  subject do 
    described_class.new(:a_method, 
                        [Specification::Only.string, Specification::Only.number],
                        Specification::Only.symbol)
  end

  it_behaves_like "an instance method signature"

  its(:idempotent?) { should be_true }
end

