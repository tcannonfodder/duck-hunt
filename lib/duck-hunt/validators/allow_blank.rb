module DuckHunt
  module Validators
    class AllowBlank < Validator
      UNICODE_WHITESPACE_CHARS = [9, 10, 11, 12, 13, 32, 133, 160, 5760, 6158, 8192, 8193, 8194, 8195, 8196, 8197, 8198, 8199, 8200, 8201, 8202, 8232, 8233, 8239, 8287, 12288].pack("U*")
      WHITESPACE_RE = /[#{UNICODE_WHITESPACE_CHARS}]+/u
      attr_reader :value
      def initialize(*args)
        @value = args[0]
        raise ArgumentError, "a value must be provided" if @value.nil?
      end

      def valid?(value)
        # return true if empty values are allowed
        if @value
          return true
        else
          return false if value.empty?
          return value !~ WHITESPACE_RE
        end
      end

      def error_message
        if @value
          return "blank values allowed"
        else
          return "blank values not allowed"
        end
      end
    end
  end
end