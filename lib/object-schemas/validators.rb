module ObjectSchemas
  module Validators
    autoload :Validator, File.dirname(__FILE__) + "/validators/validator.rb"
    autoload :Matches, File.dirname(__FILE__) + "/validators/matches.rb"
  end
end