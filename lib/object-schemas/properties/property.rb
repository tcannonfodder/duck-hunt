module ObjectSchemas
	module Properties
		class Property
			# the base class for the individual properties that make up a schema
			# a property is valid if:
			# 1. The value is required and has not been provided
			# 2. The value provided `matches_type?`
			# 3. Each of the attached validators returns `true` when `valid?` is called
			include ObjectSchemas::Properties::ValidatorLookup
			attr_reader :required

			def initialize(options= {})
				options = {"required" => true}.merge(options.stringify_keys!)
				@required = options["required"]
				@validators = {}
				@errors = []

				options.delete("required")
				options.each{ |key, value| find_and_create_validator(key, value) }
			end

			def required?
				return self.required
			end

			def valid?(value)
				@errors.clear
				add_error_if_type_mismatch(value)
				check_validators(value)
				return @errors.size == 0
			end

			def add_required_error
				add_error(ObjectSchemas::REQUIRED_MESSAGE)
			end

			def errors
				@errors.dup
			end

			protected

			def add_error_if_type_mismatch(value)
				add_error(ObjectSchemas::TYPE_MISMATCH_MESSAGE) unless matches_type?(value)
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