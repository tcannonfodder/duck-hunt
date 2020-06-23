require File.expand_path('../../test_helper', __FILE__)

class DuckHuntDivisibleByValidatorTest < DuckHuntTestCase
  def setup
    @validator = DuckHunt::Validators::DivisibleBy.new(3)
  end

  test "should create an instance with the provided value" do
    validator = DuckHunt::Validators::DivisibleBy.new(3)
    assert_equal 3, validator.value
  end

  test "should raise an exception if a value is not provided" do
    assert_raises ArgumentError do
      DuckHunt::Validators::DivisibleBy.new
    end
  end

  test "returns true if the value provided is divisible by the value provided" do
    assert_equal true, @validator.valid?(3)
    assert_equal true, @validator.valid?(9)
  end

  test "returns false if the value provided is not divisible by to the value given" do
    assert_equal false, @validator.valid?(5)
  end

  test "should have the correct error message based on the value provided" do
    validator = DuckHunt::Validators::DivisibleBy.new(3)
    assert_equal "not divisible by `3`", validator.error_message
  end
end