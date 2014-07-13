module DuckHunt
	module Properties
		class Property
			# the base class for the individual properties that make up a schema
			# a property is valid if:
			# 1. The value is required and has not been provided
			# 2. The value provided `matches_type?`
			# 3. Each of the attached validators returns `true` when `valid?` is called
			include DuckHunt::Properties::ValidatorLookup
			attr_reader :required, :allow_nil

			def initialize(options= {})
				DuckHunt::HashHelpers.stringify_keys!(options)
				options = {"required" => true, "allow_nil" => false}.merge(options)
				@required 	= options["required"]
				@allow_nil = options["allow_nil"]
				@validators = {}
				@errors = []

				options.delete("required")
				options.delete("allow_nil")
				options.each{ |key, value| find_and_create_validator(key, value) }
			end

			def required?
				return self.required
			end

			def allow_nil?
				return @allow_nil
			end

			def valid?(value)
				@errors.clear
				if value.nil?
          return true if allow_nil?
          add_error(NIL_OBJECT_NOT_ALLOWED_MESSAGE)
          return false
        end

        if matches_type?(value)
					check_validators(value)
				else
					add_type_mismatch_error(value)
				end
				return @errors.size == 0
			end

			def add_required_error
				add_error(DuckHunt::REQUIRED_MESSAGE)
			end

			def errors
				@errors.dup
			end

			protected

			def add_type_mismatch_error(value)
				add_error(DuckHunt::TYPE_MISMATCH_MESSAGE)
			end

			def check_validators(value)
				@validators.values.each do |validator|
					unless validator.valid?(value)
						add_error(validator.error_message)
					end
				end
			end

			def add_error(error_message)
				@errors << error_message unless @errors.include?(error_message)
			end

			def add_validator(validator_symbol, validator_constant, *args)
        raise ValidatorAlreadyDefined, "`#{validator_symbol}` has already been defined in this schema" if @validators.has_key?(validator_symbol)
        @validators[validator_symbol] = validator_constant.new(*args)
      end

      def matches_type?(value)
      	raise NotImplementedError
      end
		end
	end
end