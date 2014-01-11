module ObjectSchemas
  module Schemas
    class HashSchema
      # Valditation is performed in the following steps:
      # 1. Check that the object being validated is of the correct type
      # 2. Iterate through each defined property and check that the object's property value is `valid?`
      # 3. If the schema validation has been set to "strict mode", check that the object doesn't have any properties that are not defined in the schema
      include Schemas::SchemaDefinition
      include Schemas::PropertyLookup

      require 'set'

      def initialize(*var)
        @properties = {}
        #a key-value pair of all the required properties in the schema, references objects in `@properties`
        @required_properties = {}
      end

      def properties
        return @properties.dup
      end

      def strict!
        @strict_mode = true
      end

      def strict_mode
        @strict_mode ||= false
      end

      def strict_mode?
        return strict_mode
      end

      protected

      def add_property(property_constant, *args)
        name = args[0].to_s
        raise PropertyAlreadyDefined, "`#{name}` has already been defined in this schema" if @properties.has_key?(args[0])
        @properties[name] = property_constant.new(*args)
        @required_properties[name] = @properties[name] if @properties[name].required?
      end
    end
  end
end