require_dependency Rails.root.join('lib', 'specification', 'signatures', 'query').to_s
require_dependency Rails.root.join('lib', 'specification', 'only').to_s

module Specification

  class SignatureDSL
    def initialize
      @arguments = []
      @return_type = nil
      @optional_arg_count = 0
    end

    def build
      signature_class.new(@name, @arguments, @return_type, @optional_arg_count)
    end

    def type(name)
      @type = name
      self
    end

    def named(name)
      @name = name
      self
    end

    def with(*args)
      last_args = args.pop
      if last_args.respond_to?(:keys)
        raise ArgumentError unless last_args.values.all? { |v| v == :optional }
        @optional_arg_count = last_args.length
        args += last_args.keys
      end
      @arguments = args
      self
    end

    def returns(return_type)
      @return_type = return_type
      self
    end


    private

    def signature_class
      {query: Specification::Signatures::Query,
       command: Specification::Signatures::Command,
      }.fetch(@type)
    end

  end

end
