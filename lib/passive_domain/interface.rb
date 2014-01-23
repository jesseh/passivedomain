module PassiveDomain
  COLLECT_INTERFACE = :collect_interface

  class InterfaceCollection < Exception
    attr_reader :attr_targets

    def initialize(attr_targets, *args, &block)
      @attr_targets = attr_targets
      super(*args, &block)
    end
  end
end
