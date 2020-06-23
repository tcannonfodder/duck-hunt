require File.expand_path('../../test_helper', __FILE__)

class DuckHuntGreaterThanOrEqualToValidatorTest < DuckHuntTestCase
  test "should create an instance with the provided value" do
    validator = DuckHunt::Validators::GreaterThanOrEqualTo.new(3)
    assert_equal 3, validator.value
  end

  test "should raise an exception if a value is not provided" do
    assert_raises ArgumentError do
      DuckHunt::Validators::GreaterThanOrEqualTo.new
    end
  end

  test "should have the correct error message based on the value provided" do
    validator = DuckHunt::Validators::GreaterThanOrEqualTo.new(3)
    assert_equal "less than `3`", validator.error_message
  end
end

class DuckHuntGreaterThanOrEqualToValueValidatorTest < DuckHuntTestCase
  def setup
    @validator = DuckHunt::Validators::GreaterThanOrEqualTo.new(3)
  end

  test "returns true if the value provided is greater than or equal to the value given" do
    assert_equal true, @validator.valid?(4)
    assert_equal true, @validator.valid?(41)
    assert_equal true, @validator.valid?(3)
  end

  test "returns false if the value provided is less than the value given" do
    assert_equal false, @validator.valid?(0)
  end
end

class DuckHuntGreaterThanOrEqualToLengthTest < DuckHuntTestCase
  def setup
    @validator = DuckHunt::Validators::GreaterThanOrEqualTo.new(3)
  end

  test "returns true if the value provided is greater than or equal to the value given" do
    assert_equal true, @validator.valid?("aaaa")
    assert_equal true, @validator.valid?([1,2,3,4])
    assert_equal true, @validator.valid?({a: 1, b: 2, c: 3})
  end

  test "returns false if the value provided is less than the value given" do
    assert_equal false, @validator.valid?("aa")
    assert_equal false, @validator.valid?([1,2])
    assert_equal false, @validator.valid?({a: 1, b: 2})
    assert_equal false, @validator.valid?({})
    assert_equal false, @validator.valid?("")
  end
end