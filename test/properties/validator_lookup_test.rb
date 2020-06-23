require File.expand_path('../../test_helper', __FILE__)


class DuckHuntPropertiesValidatorLookupTest < DuckHuntTestCase

  class ValidatorLookupTestClass
    include DuckHunt::Properties::ValidatorLookup

    def add(name)
      find_and_create_validator(name, true)
    end
  end

  test "should raise a `NotImplementedError` if the validator definition exists (classes using this module must implement `add_validator`" do
    property = ValidatorLookupTestClass.new
    assert_raises NotImplementedError do
      property.add("test")
    end
  end

  test "should raise Name if the validator definition does not exist (it was not found)" do
    property = ValidatorLookupTestClass.new
    assert_raises NameError do
      property.add("herp")
    end
  end
end