module DuckHunt
  module Validators
    class AcceptedValues < Validator
      attr_reader :values
      def initialize(*args)
        @values = args[0]
        raise ArgumentError, "an array must be provided" unless @values.is_a? Array
      end

      def valid?(value)
        return @values.include? value
      end

      def error_message
        return "not an accepted value"
      end
    end
  end
end