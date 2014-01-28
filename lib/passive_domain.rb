require_relative "passive_domain/validation_error"
require_relative "passive_domain/class_methods"
require_relative "passive_domain/cache"
require_relative "passive_domain/interface"

module PassiveDomain
  include ClassMethods
  include Cache
end

