module ObjectSchemas
	class Schema
	# The base class for the schema types that can be defined.
	#
	# It is responsible for the following:
	# * using the block passed through the `define` method to define the Schema for this instance
	# * Finding the correct Property subclass based on the method name in the `define` class (e.g: `schema.string "name"`)
	# * Accepting the `strict!` method, which sets Schema validation to strict mode
	# * Storing/Retrieving the Property instances defined as part of the schema
	# * Validating an object against the schema
	
	#
	# This is an abstract class, instances of it cannot be created
	# 
	# Subclasses of Schema are required to implement:
	# * `matches_type?(object_being_validated)`: confirms that the object being validated is of the correct type
	#
	# Valditation is performed in the following steps:
	# 1. Check that the object being validated is of the correct type
	# 2. Validate the presence of all required parameters
	# 3. If the schema validation has been set to "strict mode", check that the object doesn't have any properties that are not defined in the schema
	# 4. Iterate through each defined property and check that the object's property value is `valid?`

	class << self
		# Make this class abstract.
  	private :new
	end

	end
end