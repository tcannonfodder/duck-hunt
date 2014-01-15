module ObjectSchemas
  module Validators
    class RejectedValues < Validator
      attr_reader :values
      def initialize(*args)
        @values = args[0]
        raise ArgumentError, "an array must be provided" unless @values.is_a? Array
      end

      def valid?(value)
        return (@values.include? value) == false
      end

      def error_message
        return "a rejected value"
      end
    end
  end
end