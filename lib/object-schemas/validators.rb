module ObjectSchemas
  module Validators
    autoload :Validator, File.dirname(__FILE__) + "/validators/validator.rb"
    autoload :Matches, File.dirname(__FILE__) + "/validators/matches.rb"
    autoload :GreaterThan, File.dirname(__FILE__) + "/validators/greater_than.rb"
    autoload :GreaterThanOrEqualTo, File.dirname(__FILE__) + "/validators/greater_than_or_equal_to.rb"
    autoload :LessThan, File.dirname(__FILE__) + "/validators/less_than.rb"
    autoload :LessThanOrEqualTo, File.dirname(__FILE__) + "/validators/less_than_or_equal_to.rb"
    autoload :EqualTo, File.dirname(__FILE__) + "/validators/equal_to.rb"
    autoload :NotEqualTo, File.dirname(__FILE__) + "/validators/not_equal_to.rb"
    autoload :DivisibleBy, File.dirname(__FILE__) + "/validators/divisible_by.rb"
    autoload :NotDivisibleBy, File.dirname(__FILE__) + "/validators/not_divisible_by.rb"
    autoload :AcceptedValues, File.dirname(__FILE__) + "/validators/accepted_values.rb"
    autoload :RejectedValues, File.dirname(__FILE__) + "/validators/rejected_values.rb"
  end
end