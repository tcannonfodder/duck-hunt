module DuckHunt
  module Validators
    class AllowEmpty < Validator
      attr_reader :value
      def initialize(*args)
        @value = args[0]
        raise ArgumentError, "a value must be provided" if @value.nil?
      end

      def valid?(value)
        # return true if empty values are allowed
        return true if @value
        return !value.empty?
      end

      def error_message
        if @value
          return "empty values allowed"
        else
          return "empty values not allowed"
        end
      end
    end
  end
end