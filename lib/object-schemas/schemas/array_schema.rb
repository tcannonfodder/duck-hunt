module ObjectSchemas
  module Schemas
    class ArraySchema
      # There are two ways to define the schema of an array:
      # * All items in the array have the same definition (integer, specific hash, etc.)
      # * The order of the items in the array matters
      #   * each item in the array can have a different definition (e.g.: [1,"hello", { :hash=>"here" }])
      #   * The array definition can also include an optional set of items.
      #
      # These two types cannot be mixed
      #
      # The Array Schema also accepts some options during definition:
      # * validates_uniqueness: if true, the array is invalid if it has duplicates (false by default)
      # * min_size: the array must be at least this large (nil by default)
      # * max_size: the array cannot be any larger (nil by default)
      #
      # Validation is performed in the following steps:
      # 1. If the object is nil and nil objects are allowed, then return true
      # 2. Check that the object is an array
      # 3. If the `validates_uniqueness` flag is set, check that the array's entries are unique.
      # 4. If the schema is a single-type:
      #   1. Check that it falls within the specified min/max range
      #   2. Check that every entry is valid according to the defined single type property
      # 5. If the Schema is a tuple:
      #   1. Check that the total number of entries is within the following range:
      #      (tuple_properties) <= (number of enties) <= (tuple_properties + optional_tuple_properties)
      #   2. Check that each entry is valid according to the defined type in the tuple properties
      include Schemas::SchemaDefinition
      include Schemas::PropertyLookup

      DUPLICATE_ITEMS_NOT_ALLOWED_MESSAGE = "duplicate items are not allowed"

      def initialize(var={})
        options = {"validates_uniqueness" => false, "min_size" => nil, "max_size" => nil, "allow_nil" => false}.merge(var.stringify_keys!)
        @single_type_property  = nil
        @tuple_properties = nil
        @optional_tuple_properties = nil
        @validates_uniqueness = options["validates_uniqueness"]
        @min_size = options["min_size"]
        @max_size = options["max_size"]
        @allow_nil = options["allow_nil"]
        @errors = {}
      end

      def single_type_property
        @single_type_property
      end

      def tuple_properties
        return nil if @tuple_properties.nil?
        @tuple_properties.properties
      end

      def optional_tuple_properties
        return nil if @optional_tuple_properties.nil?
        @optional_tuple_properties.properties
      end

      def validates_uniqueness
        return @validates_uniqueness
      end

      def validates_uniqueness?
        return @validates_uniqueness
      end

      def allow_nil
        return @allow_nil
      end

      def allow_nil?
        return @allow_nil
      end

      def min_size
        return @min_size
      end

      def max_size
        return @max_size
      end

      def errors
        return @errors.stringify_keys
      end

      def items(&block)
        raise InvalidSchema, "cannot mix single-type and tuple definitions" unless @single_type_property.nil?
        @tuple_properties = TupleProperties.new(&block)
      end

      def optional_items(&block)
        raise InvalidSchema, "cannot mix single-type and tuple definitions" unless @single_type_property.nil?
        @optional_tuple_properties = TupleProperties.new(&block)
      end

      def validate?(object)
        if object.nil?
          return true if allow_nil?
          add_base_error_message(NIL_OBJECT_NOT_ALLOWED_MESSAGE)
          return false
        end

        return false unless matches_type?(object)

        if validates_uniqueness? and not has_unique_entries?(object)
          add_base_error_message(DUPLICATE_ITEMS_NOT_ALLOWED_MESSAGE)
          return false
        end

        return validate_single_type?(object) if single_type_schema?
        return validate_tuple?(object) if tuple_schema?
      end

      protected

      def add_property(property_constant, *args)
        raise InvalidSchema, "cannot mix single-type and tuple definitions" unless @tuple_properties.nil? and @optional_tuple_properties.nil?
        raise InvalidSchema, "single type property has already been defined for this schema" unless @single_type_property.nil?
        @single_type_property = property_constant.new(*args)
      end


      def matches_type?(object_being_validated)
        unless object_being_validated.is_a? Array
          add_base_error_message(ObjectSchemas::TYPE_MISMATCH_MESSAGE)
          return false
        end
        return true
      end

      def add_base_error_message(message)
        @errors[:base] = [] if @errors[:base].nil?
        @errors[:base] << message
      end

      def single_type_schema?
        return !@single_type_property.nil?
      end

      def tuple_schema?
        @tuple_properties.nil? == false or @optional_tuple_properties.nil? == false
      end

      def has_unique_entries?(object)
        return object.uniq.size == object.size
      end

      def validate_single_type?(object)
        object_size = object.size

        if !min_size.nil? and object_size < min_size
          add_base_error_message(generate_under_minimum_message(min_size, object_size))
          return false
        end

        if !max_size.nil? and object_size > max_size
          add_base_error_message(generate_over_maximum_message(max_size, object_size))
          return false
        end

        object.each_with_index{ |item, index|
          unless single_type_property.valid?(item)
            add_base_error_message(generate_wrong_type_message(index)) and return false 
          end
        }

        return true #passed all tests
      end

      def validate_tuple?(object)
        object_size = object.size

        if object_size < minimum_tuple_size
          add_base_error_message(generate_under_minimum_message(minimum_tuple_size, object_size))
          return false
        end

        if object_size > maximum_tuple_size
          add_base_error_message(generate_over_maximum_message(maximum_tuple_size, object_size))
          return false
        end

        unless tuple_properties.nil?
          # check that each required entry has the correct type in the tuple
          tuple_properties.each_with_index{ |property, index|
            add_base_error_message(generate_wrong_type_message(index)) and return false unless property.valid?(object[index]) 
          }
        end

        if !optional_tuple_properties.nil? and object.size > 0
          # check that each optional entry has the correct type in the tuple
          optional_tuple_properties.each_with_index{ |property, index|
            object_index = minimum_tuple_size + index
            if object_index > (object.size - 1)
              break #stop looking at optional properties if we've reached the end of the array
            end
            add_base_error_message(generate_wrong_type_message(object_index)) and return false unless property.valid?(object[object_index]) 
          }
        end

        return true #passed all tests
      end

      def minimum_tuple_size
        return tuple_properties.nil? ? 0 : tuple_properties.size
      end

      def maximum_tuple_size
        optional_tuple_size = optional_tuple_properties.nil? ? 0 : optional_tuple_properties.size
        return minimum_tuple_size + optional_tuple_size
      end

      def generate_under_minimum_message(minimum_size, object_size)
        return "expected at least #{minimum_size} item(s) but got #{object_size} item(s)"
      end

      def generate_over_maximum_message(maximum_size, object_size)
        return "expected at most #{maximum_size} item(s) but got #{object_size} item(s)"
      end

      def generate_wrong_type_message(index)
        return "wrong type at index #{index}"
      end

      class TupleProperties
        include Schemas::PropertyLookup

        def initialize(*var)
          raise ArgumentError, "a block of properties must be given to define the tuple items" unless block_given?
          @properties = []
          yield self
        end

        def properties
          @properties.dup
        end

        protected

        def add_property(property_constant, *args)
          @properties << property_constant.new(*args)
        end
      end
    end
  end
end