require_relative "specification/only"
require_relative "specification/signatures/query"
require_relative "specification/signatures/command"
require_relative "specification/signatures/initializer"
require_relative "specification/interface"

module Specification
  def self.create(&block)
    Interface.new([])
  end
end
