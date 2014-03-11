require 'spec_helper'
require_dependency Rails.root.join('lib', 'specification', 'signatures', 'command').to_s
require_dependency Rails.root.join('spec', 'lib', 'specification', 'signatures', 'base_shared').to_s

describe Specification::Signatures::Initializer do
  subject do 
    described_class.new([Specification::Only.string, Specification::Only.number])
  end

  it_behaves_like "a signature"

  its(:idempotent?) { should be_false }
  it { expect(subject.valid_response?('yada')).to be_true }
end

