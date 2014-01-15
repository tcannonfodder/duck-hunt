module ObjectSchemas
	module Properties
    autoload :ValidatorLookup, File.dirname(__FILE__) + "/properties/validator_lookup.rb"
		autoload :Property, File.dirname(__FILE__) + "/properties/property.rb"
    autoload :Integer, File.dirname(__FILE__) + "/properties/integer.rb"
    autoload :NestedHash, File.dirname(__FILE__) + "/properties/nested_hash.rb"
    autoload :Array, File.dirname(__FILE__) + "/properties/array.rb"
	end
end