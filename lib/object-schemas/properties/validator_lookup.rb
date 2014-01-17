module ObjectSchemas
  module Properties
    module ValidatorLookup
      protected
      def find_and_create_validator(validator_name, *args)
        #convert the validator name into camel case and turn it into a symbol.
        camelized_string = ObjectSchemas::StringHelpers.camelize(validator_name.to_s)
        validator_symbol = camelized_string.to_sym

        validator_constant = get_validator_constant(validator_symbol)
        add_validator(validator_symbol, validator_constant, *args)
      end

      def validator_definition_exists?(validator)
        ObjectSchemas::Validators.const_defined?(validator)
      end

      def get_validator_constant(validator)
        ObjectSchemas::Validators.const_get(validator)
      end

      def add_validator(validator_symbol, validator_constant, *args)
        raise NotImplementedError
      end
    end
  end
end