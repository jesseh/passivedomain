require 'spec_helper'
require_dependency Rails.root.join('lib', 'specification', 'signatures', 'command').to_s
require_dependency Rails.root.join('spec', 'lib', 'specification', 'signatures', 'base_shared').to_s

describe Specification::Signatures::Command do
  it_behaves_like "a signature"
end

