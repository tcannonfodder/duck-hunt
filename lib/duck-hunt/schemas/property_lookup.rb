module DuckHunt
  module Schemas
    module PropertyLookup
      def method_missing(method_name, *args, &block)
        #convert the method name into camel case and turn it into a symbol.
        camelized_string = DuckHunt::StringHelpers.camelize(method_name.to_s)
        property_symbol = camelized_string.to_sym
        #check if this property has been defined.
        if property_definition_exists?(property_symbol)
          property_constant = get_property_constant(property_symbol)
          add_property(property_constant, *args, &block)
        else
          super
        end
      end

      protected

      def property_definition_exists?(property)
        DuckHunt::Properties.const_defined?(property)
      end

      def get_property_constant(property)
        DuckHunt::Properties.const_get(property)
      end

      def add_property(property_constant, *args, &block)
        raise NotImplementedError
      end
    end
  end
end