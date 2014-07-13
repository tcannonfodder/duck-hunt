module DuckHunt
	class MethodNotDefined < StandardError; end
	class AbstractClass < StandardError; end
	class PropertyAlreadyDefined < StandardError; end
  class ValidatorAlreadyDefined < StandardError; end
  class InvalidSchema < StandardError; end

  TYPE_MISMATCH_MESSAGE = "wrong type"
  REQUIRED_MESSAGE = "required"
  NIL_OBJECT_NOT_ALLOWED_MESSAGE = "nil object not allowed"

  autoload :StringHelpers, File.dirname(__FILE__) + '/duck-hunt/string_helpers.rb'
  autoload :HashHelpers, File.dirname(__FILE__) + '/duck-hunt/hash_helpers.rb'
	autoload :Schemas, File.dirname(__FILE__) + '/duck-hunt/schemas.rb'
	autoload :Properties, File.dirname(__FILE__) + '/duck-hunt/properties.rb'
  autoload :Validators, File.dirname(__FILE__) + '/duck-hunt/validators.rb'
end