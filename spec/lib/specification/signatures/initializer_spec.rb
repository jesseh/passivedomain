require 'spec_helper'
require_dependency Rails.root.join('lib', 'specification', 'signatures', 'command').to_s
require_dependency Rails.root.join('spec', 'lib', 'specification', 'signatures', 'base_shared').to_s

describe Specification::Signatures::Initializer do
  subject do 
    described_class.new([Specification::Only.string, Specification::Only.number], 1)
  end

  it_behaves_like "a signature"

  its(:idempotent?) { should be_false }
  it { expect(subject.valid_response?('yada')).to be_true }

  it "handles optional arguments" do
    expect( subject.valid_arguments?(['yada', 1, :wrong_headed]) ).to be_false
    expect( subject.valid_arguments?(['yada', 1]) ).to be_true
    expect( subject.valid_arguments?(['yada']) ).to be_true
    expect( subject.valid_arguments?([]) ).to be_false
  end
end

