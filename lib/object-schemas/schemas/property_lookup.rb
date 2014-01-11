module ObjectSchemas
  module Schemas
    module PropertyLookup
      def method_missing(method_name, *args, &block)
        #convert the method name into camel case and turn it into a symbol.
        property_symbol = method_name.to_s.camelize.to_sym
        #check if this property has been defined.
        if property_definition_exists?(property_symbol)
          property_constant = get_property_constant(property_symbol)
          add_property(property_constant, *args)
        else
          super
        end
      end

      protected

      def property_definition_exists?(property)
        ObjectSchemas::Properties.const_defined?(property)
      end

      def get_property_constant(property)
        ObjectSchemas::Properties.const_get(property)
      end

      def add_property(property_constant, *args)
        raise NotImplementedError
      end
    end
  end
end