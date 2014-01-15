module ObjectSchemas
  module Validators
    class EqualTo < Validator
      attr_reader :value
      def initialize(*args)
        @value = args[0]
        raise ArgumentError, "a value must be provided" if @value.nil?
      end

      def valid?(value)
        return value == @value
      end

      def error_message
        return "not equal to `#{@value}`"
      end
    end
  end
end