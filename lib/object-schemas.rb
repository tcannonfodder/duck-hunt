module ObjectSchemas
	class MethodNotDefined < StandardError; end
	class AbstractClass < StandardError; end
	class PropertyAlreadyDefined < StandardError; end
  class ValidatorAlreadyDefined < StandardError; end
  class InvalidSchema < StandardError; end

  TYPE_MISMATCH_MESSAGE = "wrong type"
  REQUIRED_MESSAGE = "required"
  NIL_OBJECT_NOT_ALLOWED_MESSAGE = "nil object not allowed"

  autoload :StringHelpers, File.dirname(__FILE__) + '/object-schemas/string_helpers.rb'
  autoload :HashHelpers, File.dirname(__FILE__) + '/object-schemas/hash_helpers.rb'
	autoload :Schemas, File.dirname(__FILE__) + '/object-schemas/schemas.rb'
	autoload :Properties, File.dirname(__FILE__) + '/object-schemas/properties.rb'
  autoload :Validators, File.dirname(__FILE__) + '/object-schemas/validators.rb'
end