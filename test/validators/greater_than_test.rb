require File.expand_path('../../test_helper', __FILE__)

class DuckHuntGreaterThanValidatorTest < DuckHuntTestCase
  test "should create an instance with the provided value" do
    validator = DuckHunt::Validators::GreaterThan.new(3)
    assert_equal 3, validator.value
  end

  test "should raise an exception if a value is not provided" do
    assert_raises ArgumentError do
      DuckHunt::Validators::GreaterThan.new
    end
  end

  test "should have the correct error message based on the value provided" do
    validator = DuckHunt::Validators::GreaterThan.new(3)
    assert_equal "less than `3`", validator.error_message
  end
end

class DuckHuntGreaterThanValueValidationTest < DuckHuntTestCase
  def setup
    @validator = DuckHunt::Validators::GreaterThan.new(3)
  end

  test "returns true if the value provided is greater than the value given" do
    assert_equal true, @validator.valid?(4)
    assert_equal true, @validator.valid?(41)
  end

  test "returns false if the value provided is less than the value provided" do
    assert_equal false, @validator.valid?(3)
    assert_equal false, @validator.valid?(0)
  end
end

class DuckHuntGreaterThanValidationLengthCheckTest < DuckHuntTestCase
  def setup
    @validator = DuckHunt::Validators::GreaterThan.new(3)
  end

  test "returns true if the value provided is greater than the value given" do
    assert_equal true, @validator.valid?("aaaa")
    assert_equal true, @validator.valid?([1,2,3,4])
    assert_equal true, @validator.valid?({a: 1, b: 2, c: 3, d: 4})
  end

  test "returns false if the value provided is less than the value given" do
    assert_equal false, @validator.valid?("aaa")
    assert_equal false, @validator.valid?([1,2,3])
    assert_equal false, @validator.valid?({a: 1, b: 2, c: 3})
    assert_equal false, @validator.valid?({})
    assert_equal false, @validator.valid?("")
  end
end