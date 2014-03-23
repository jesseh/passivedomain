require_dependency Rails.root.join('lib', 'specification').to_s
require_dependency Rails.root.join('lib', 'specification', 'interface').to_s
require_dependency Rails.root.join('lib', 'specification', 'signature_dsl').to_s

module Specification

  class InterfaceDSL
    attr_accessor :signatures

    def initialize(&block)
      @signature_builders = []
      instance_eval &block if block_given?
    end

    def build
      Interface.new signatures
    end

    def querying(method_symbol)
      add_signature_builder(:query, method_symbol)
    end

    def commanding(method_symbol)
      add_signature_builder(:command, method_symbol)
    end

    private

    def add_signature_builder(role, method_symbol)
      builder = SignatureDSL.new.type(role).named(method_symbol)
      @signature_builders << builder
      builder
    end

    def signatures
      @signature_builders.map(&:build)
    end

    def a
      Specification::Only
    end

  end
end
