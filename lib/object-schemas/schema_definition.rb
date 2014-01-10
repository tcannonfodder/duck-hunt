module ObjectSchemas
	module SchemaDefinition
		# This module encompasses all of the logic required to define a schema, along with the necessary instance variables.
		# Schema Definition requires the following:
		# * using the block passed through the `define` method to define the Schema for this instance
		# * Finding the correct Property subclass based on the method name in the `define` class (e.g: `schema.string "name"`)
		# * Accepting the `strict!` method, which sets Schema validation to strict mode
		# * Storing/Retrieving the Property instances defined as part of the schema

		# Classes that defin a schema are required to implement:
		# * `matches_type?(object_being_validated)`: confirms that the object being validated is of the correct type

		# Include class-level methods
		def self.included(base)
	    base.extend(ClassMethods)
	  end

	  module ClassMethods
	    def define(*args, &block)
	    	self.new(&block)
	    end
	  end


	  def strict!
	  	@strict_mode = true
	  end

	  def strict_mode
	  	@strict_mode ||= false
	  end

	  def strict_mode?
	  	return strict_mode
	  end

	  def properties
	  	raise NotImplementedError
	  end

	  def method_missing(method_name, *args, &block)
	  	#convert the method name into camel case and turn it into a symbol.
	  	property_symbol = method_name.to_s.camelize.to_sym
	  	#check if this property has been defined.
	  	if property_definition_exists?(property_symbol)
	  		property_constant = get_property_constant(property_symbol)
	  		add_property(property_constant, *args)
	  	else
	  		super
	  	end
	  end

		def property_definition_exists?(property)
			ObjectSchemas::Properties.const_defined?(property)
		end

		def get_property_constant(property)
			ObjectSchemas::Properties.const_get(property)
		end

		protected

		def add_property(property_constant, *args)
	  	raise NotImplementedError
	  end

	end
end