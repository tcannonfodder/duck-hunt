module ObjectSchemas
	module Properties
		class Property
			# the base class for the individual properties that make up a schema
			attr_accessor :name
			attr_accessor :required

			def initialize(name, options= {})
				options = {"required" => true}.merge(options.stringify_keys!)
				@name = name
				@required = options["required"]
			end

			def required?
				return self.required
			end
		end
	end
end