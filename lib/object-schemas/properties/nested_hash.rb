module ObjectSchemas
  module Properties
    class NestedHash
      # Used when a hash is a property of a schema.
      # Allows us to "nest" schemas (eg: an array in a hash, an array of hashes)
      attr_reader :required

      def initialize(options= {}, &block)
        raise ArgumentError, "a block must be given to define the hash" unless block_given?
        options = {"required" => true}.merge(options.stringify_keys!)
        @required = options["required"]
        @required_but_not_present = false
        @schema = ObjectSchemas::Schemas::HashSchema.define options, &block
      end

      def required?
        return self.required
      end

      def properties
        return @schema.properties
      end

      def strict_mode
        return @schema.strict_mode
      end

      def strict_mode?
        return strict_mode
      end

      def allow_nil
        return @schema.allow_nil
      end

      def allow_nil?
        return @schema.allow_nil
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