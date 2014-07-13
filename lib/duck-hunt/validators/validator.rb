module DuckHunt
	module Validators
		class Validator
      def initialize(*args)
      end

      def valid?(value)
        raise NotImplementedError
      end

      def error_message
        raise NotImplementedError
      end
    end
	end
end