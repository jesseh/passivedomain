require 'spec_helper'
require_dependency Rails.root.join('lib', 'specification', 'signatures', 'query').to_s
require_dependency Rails.root.join('spec', 'lib', 'specification', 'signatures', 'base_shared').to_s

describe Specification::Signatures::Query do
  it_behaves_like "a signature"
end

