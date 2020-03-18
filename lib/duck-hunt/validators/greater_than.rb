module DuckHunt
  module Validators
    class GreaterThan < Validator
      attr_reader :value
      def initialize(*args)
        @value = args[0]
        raise ArgumentError, "a value must be provided" if @value.nil?
      end

      def valid?(value)
        if value.respond_to?(:length)
          return value.length > @value
        else
          return value > @value
        end
      end

      def error_message
        return "less than `#{@value}`"
      end
    end
  end
end