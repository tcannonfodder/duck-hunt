module DuckHunt
  module Validators
    class Matches < Validator
      attr_reader :regex
      def initialize(*args)
        @regex = Regexp.new(args[0])
      end

      def valid?(value)
        return @regex.match(value) != nil
      end

      def error_message
        return "No matches for Regexp"
      end
    end
  end
end