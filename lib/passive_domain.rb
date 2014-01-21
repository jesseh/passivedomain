require_relative "passive_domain/validation_error"
require_relative "passive_domain/class_methods"
require_relative "passive_domain/cache"

module PassiveDomain
  include ClassMethods
  include Cache
end

