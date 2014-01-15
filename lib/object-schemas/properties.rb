module ObjectSchemas
	module Properties
    autoload :ValidatorLookup, File.dirname(__FILE__) + "/properties/validator_lookup.rb"
		autoload :Property, File.dirname(__FILE__) + "/properties/property.rb"
    autoload :Integer, File.dirname(__FILE__) + "/properties/integer.rb"
    autoload :Float, File.dirname(__FILE__) + "/properties/float.rb"
    autoload :NestedHash, File.dirname(__FILE__) + "/properties/nested_hash.rb"
    autoload :Array, File.dirname(__FILE__) + "/properties/array.rb"
    autoload :String, File.dirname(__FILE__) + "/properties/string.rb"
    autoload :Boolean, File.dirname(__FILE__) + "/properties/boolean.rb"
	end
end