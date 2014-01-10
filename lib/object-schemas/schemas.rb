module ObjectSchemas
  module Schemas
    autoload :SchemaDefinition, File.dirname(__FILE__) + "/schemas/schema_definition.rb"
    autoload :Schema, File.dirname(__FILE__) + "/schemas/schema.rb"
  end
end