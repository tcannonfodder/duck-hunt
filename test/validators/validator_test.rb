require File.expand_path('../../test_helper', __FILE__)

describe ObjectSchemas::Validators::Validator, "initialization" do
  it "should allow an instance to be created with any number of arguments" do
    ObjectSchemas::Validators::Validator.new("hello", "world")
  end
end

describe ObjectSchemas::Validators::Validator, "methods to be defined in subclasses" do
  it "raise NotImplementedError if valid? has not been defined" do
    validator = ObjectSchemas::Validators::Validator.new
    lambda{
      validator.valid?("test")
    }.must_raise(NotImplementedError)
  end

  it "raise NotImplementedError if valid? has not been defined" do
    validator = ObjectSchemas::Validators::Validator.new
    lambda{
      validator.error_message
    }.must_raise(NotImplementedError)
  end
end