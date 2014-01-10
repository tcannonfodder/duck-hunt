module ObjectSchemas
	class Schema
		include ObjectSchemas::SchemaDefinition

	class << self
		# Make this class abstract.
  	private :new
	end

	end
end