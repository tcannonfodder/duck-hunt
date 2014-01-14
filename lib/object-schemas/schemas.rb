module ObjectSchemas
  module Schemas
    autoload :SchemaDefinition, File.dirname(__FILE__) + "/schemas/schema_definition.rb"
    autoload :PropertyLookup, File.dirname(__FILE__) + "/schemas/property_lookup.rb"
    autoload :HashSchema, File.dirname(__FILE__) + "/schemas/hash_schema.rb"
    autoload :ArraySchema, File.dirname(__FILE__) + "/schemas/array_schema.rb"
  end
end