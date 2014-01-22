require_relative "ask"
module PassiveDomain

  class Builder

    attr_reader :attribute_targets, :attribute_values

    def initialize(*targets)
      @attribute_targets = parse_targets( targets ).freeze
      @attribute_values  = attribute_targets.values.freeze
    end

    private

    def parse_targets(targets)
      attrs = {}
      targets.each do |target_or_hash|
        if target_or_hash.respond_to? :each
          target_or_hash.each do |source_message, target|
            attrs[source_message] = underscore(target.to_s).to_sym
          end
        else
          source = target_or_hash
          target = source.instance_of?(Ask) ? source.source : source

          attrs[source] = underscore(target.to_s).to_sym
        end
      end
      attrs
    end

    # method from Rails ActiveSupport.
    def underscore(str)
      str.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end

  end

end
