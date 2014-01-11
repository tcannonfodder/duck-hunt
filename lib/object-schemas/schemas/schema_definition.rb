module ObjectSchemas
	module Schemas
		module SchemaDefinition
			# This module encompasses all of the logic required to define a schema, along with the necessary instance variables.
			# Schema Definition requires the following:
			# * using the block passed through the `define` method to define the Schema for this instance
			# * Finding the correct Property subclass based on the method name in the `define` class (e.g: `schema.string "name"`)
			# * Accepting the `strict!` method, which sets Schema validation to strict mode
			# * Storing/Retrieving the Property instances defined as part of the schema

			# Include class-level methods
			def self.included(base)
		    base.extend(ClassMethods)
		  end

		  module ClassMethods
		    def define(*args, &block)
		    	instance = self.new
		    	instance.instance_eval(&block)
		    	return instance
		    end
		  end
		end
	end
end