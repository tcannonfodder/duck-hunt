module ObjectSchemas
  module Schemas
    class Schema
      include Schemas::SchemaDefinition

      def initialize(*var)
        @properties = {}
        #a key-value pair of all the required properties in the schema, references objects in `@properties`
        @required_properties = {}
        yield self if block_given?
      end

      def properties
        return @properties.dup
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