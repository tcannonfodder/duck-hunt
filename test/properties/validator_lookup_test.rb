require File.expand_path('../../test_helper', __FILE__)

class ValidatorLookupTestClass
  include DuckHunt::Properties::ValidatorLookup

  def add(name)
    find_and_create_validator(name, true)
  end
end

describe DuckHunt::Properties::ValidatorLookup, "Adding a validator to the property" do
  it "should raise a `NotImplementedError` if the validator definition exists (classes using this module must implement `add_validator`" do
    property = ValidatorLookupTestClass.new
    lambda {
      property.add("test")
    }.must_raise(NotImplementedError)
  end

  it "should raise Name if the validator definition does not exist (it was not found)" do
    property = ValidatorLookupTestClass.new
    lambda {
      property.add("herp")
    }.must_raise(NameError)
  end
end