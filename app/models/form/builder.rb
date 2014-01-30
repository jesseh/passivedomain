module Form
  class Builder

    include ActionView::Helpers::TagHelper

    def initialize(mapper,&block)
      @mapper = mapper

      assert_sources_used { block.call(self) }
    end

    def input(obj)
      sources << sources_for(obj)
      render input_for(obj)
    end

    private

    attr_reader :mapper

    def sources_for(obj)
      if obj.respond_to? :input_sources
        obj.input_sources
      else
        obj
      end
    end

    def input_for(obj)

    end

    def renders
      []
    end

    def render(input)
      content_tag(:input, :name => obj)
    end

    def sources
      @sources ||= []
    end

    def assert_sources_used(&block)
      block.call
      raise "Unused inputs #{unused_sources.join(', ')}" if unused_sources.any?
    end

    def unused_sources
      mapper.input_sources.reject{|source| sources.include? source }
    end

  end
end
