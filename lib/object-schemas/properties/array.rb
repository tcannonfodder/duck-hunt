module ObjectSchemas
  module Properties
    class Array
      # Used when an array is a property of a schema.
      # Allows us to "nest" schemas (eg: an array in a array, an array of arrays)
      attr_reader :required

      def initialize(options= {}, &block)
        raise ArgumentError, "a block must be given to define the array" unless block_given?
        ObjectSchemas::HashHelpers.stringify_keys!(options)
        options = {"required" => true}.merge(options)
        @required = options["required"]
        @required_but_not_present = false
        @schema = ObjectSchemas::Schemas::ArraySchema.define options, &block
      end

      def required?
        return self.required
      end

      def single_type_property
        return @schema.single_type_property
      end

      def tuple_properties
        return @schema.tuple_properties
      end

      def optional_tuple_properties
        return @schema.optional_tuple_properties
      end

      def validates_uniqueness
        return @schema.validates_uniqueness
      end

      def validates_uniqueness?
        return @schema.validates_uniqueness?
      end

      def allow_nil
        return @schema.allow_nil
      end

      def allow_nil?
        return @schema.allow_nil?
      end

      def min_size
        return @schema.min_size
      end

      def max_size
        return @schema.max_size
      end

      def errors
        return @schema.errors
      end

      def valid?(value)
        @required_but_not_present = false
        return @schema.validate?(value)
      end

      def add_required_error
        @required_but_not_present = true
      end

      def errors
        errors = @schema.errors
        if @required_but_not_present
          errors[:base] = [] if errors[:base].nil?
          errors[:base] << ObjectSchemas::REQUIRED_MESSAGE
        end

        return errors
      end
    end
  end
end