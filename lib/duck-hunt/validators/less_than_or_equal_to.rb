module DuckHunt
  module Validators
    class LessThanOrEqualTo < Validator
      attr_reader :value
      def initialize(*args)
        @value = args[0]
        raise ArgumentError, "a value must be provided" if @value.nil?
      end

      def valid?(value)
        return value <= @value
      end

      def error_message
        return "greater than `#{@value}`"
      end
    end
  end
end