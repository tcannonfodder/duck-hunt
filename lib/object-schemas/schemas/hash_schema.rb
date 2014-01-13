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
        @errors = {}
      end

      def properties
        return @properties.dup
      end

      def relaxed!
        @strict_mode = false
      end

      def strict_mode
        @strict_mode = true if @strict_mode.nil?
        return @strict_mode
      end

      def strict_mode?
        return strict_mode
      end

      def validate?(object_being_validated)
        @errors.clear #reset since we are revalidating
        return false unless matches_type?(object_being_validated)
        #now that we know the type matches, we can stringify the hash's keys
        object_being_validated.stringify_keys!
        return false unless conforms_to_strict_mode_setting?(object_being_validated)
        return false unless objects_properties_are_valid_and_has_all_required_properties?(object_being_validated)
        return true
      end

      def errors
        @properties.each{|name, property| @errors[name] = property.errors unless property.errors.empty?  }
        return @errors.stringify_keys
      end

      protected

      def add_property(property_constant, *args)
        name = args.shift.to_s
        raise ArgumentError, "Property name cannot be blank" if name.nil? or name.empty?
        raise PropertyAlreadyDefined, "`#{name}` has already been defined in this schema" if @properties.has_key?(name)
        @properties[name] = property_constant.new(*args)
        if @properties[name].required?
          @required_properties[name] = @properties[name]
        end
      end

      def add_base_error_message(message)
        @errors[:base] = [] if @errors[:base].nil?
        @errors[:base] << message
      end

      def conforms_to_strict_mode_setting?(object_being_validated)
        object_properties_set = object_being_validated.keys.to_set
        schema_properties_set = properties.keys.to_set
        # if we are in strict mode, we have to check that the object's properties are a subset
        # of the schema (do not contain any extra properties).
        if strict_mode?
          if !(object_properties_set.subset? schema_properties_set)
            add_base_error_message("has properties not defined in schema")
            return false
          end
        end
        #passes test, or is not in strict mode
        return true
      end

      def objects_properties_are_valid_and_has_all_required_properties?(object_being_validated)
        object_valid = missing_required_properties?(object_being_validated)
        object_being_validated.each do |name, value|
          next unless properties.has_key?(name.to_s)

          # we want to validate every property, even if the object is invalid. That way, the
          # errors are correctly populated for each property
          property_is_valid = properties[name.to_s].valid?(value)

          # switch the object's validity to false if a property is invalid. This will not
          # revert back if a propety is true and the `object_valid == true` check prevents
          # unnecessary re-assignments to false
          if object_valid == true and property_is_valid == false
            object_valid = false
          end
        end

        return object_valid
      end

      def missing_required_properties?(object_being_validated)
        missing_required_properties = @required_properties.keys - object_being_validated.keys
        unless missing_required_properties.empty?
          missing_required_properties.each{|name| properties[name.to_s].add_required_error }
          return false
        end
        return true
      end

      #implemented by the class to do a top-level check that the object is even of the right type
      def matches_type?(object_being_validated)
        unless object_being_validated.is_a? Hash
          add_base_error_message(ObjectSchemas::TYPE_MISMATCH_MESSAGE)
          return false
        end
        return true
      end
    end
  end
end