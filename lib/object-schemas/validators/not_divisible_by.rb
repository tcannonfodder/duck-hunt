module ObjectSchemas
  module Validators
    class NotDivisibleBy < Validator
      attr_reader :value
      def initialize(*args)
        @value = args[0]
        raise ArgumentError, "a value must be provided" if @value.nil?
      end

      def valid?(value)
        return !(value % @value).zero?
      end

      def error_message
        return "divisible by `#{@value}`"
      end
    end
  end
end