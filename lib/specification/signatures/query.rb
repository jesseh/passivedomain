require_dependency Rails.root.join('lib', 'specification', 'signatures', 'base').to_s

module Specification
  module Signatures

    class Query
      include Signatures::Base
    end

  end
end
