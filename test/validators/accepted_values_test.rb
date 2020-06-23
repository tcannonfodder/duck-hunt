require File.expand_path('../../test_helper', __FILE__)

class DuckHuntAcceptedValuesValidatorInitializationTests < DuckHuntTestCase
  test "should create an instance with the provided value" do
    validator = DuckHunt::Validators::AcceptedValues.new([1,2,3])
    assert_equal [1,2,3], validator.values
  end

  test "should raise an exception if a value is not provided" do
    assert_raises ArgumentError do
      DuckHunt::Validators::AcceptedValues.new
    end
  end

  test "should raise an exception if the value provided is not a hash" do
    assert_raises ArgumentError do
      DuckHunt::Validators::AcceptedValues.new(3)
    end
  end
end

class DuckHuntAcceptedValuesValidationTests < DuckHuntTestCase
  def setup
    @validator = DuckHunt::Validators::AcceptedValues.new([1,2,3])
  end

  test "returns true if the value provided is one of the accepted values" do
    assert_equal true, @validator.valid?(1)
    assert_equal true, @validator.valid?(2)
    assert_equal true, @validator.valid?(3)
  end

  test "returns false if the value provided is not one of the accepted values" do
    assert_equal false, @validator.valid?(4)
    assert_equal false, @validator.valid?(0)
  end

  test "should have the correct error message based on the value provided" do
    validator = DuckHunt::Validators::AcceptedValues.new([1,2,3])
    assert_equal "not an accepted value", validator.error_message
  end
end