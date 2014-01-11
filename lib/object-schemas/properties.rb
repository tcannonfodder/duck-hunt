module ObjectSchemas
	module Properties
    autoload :ValidatorLookup, File.dirname(__FILE__) + "/properties/validator_lookup.rb"
		autoload :Property, File.dirname(__FILE__) + "/properties/property.rb"
	end
end