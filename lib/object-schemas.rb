module ObjectSchemas
	class MethodNotDefined < StandardError; end
	class AbstractClass < StandardError; end
	class PropertyAlreadyDefined < StandardError; end

	autoload :Schema, File.dirname(__FILE__) + '/object-schemas/schema.rb'
	autoload :SchemaDefinition, File.dirname(__FILE__) + '/object-schemas/schema_definition.rb'
	autoload :Properties, File.dirname(__FILE__) + '/object-schemas/properties.rb'
end