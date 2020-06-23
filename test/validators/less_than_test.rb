require File.expand_path('../../test_helper', __FILE__)

class DuckHuntLessThanValidationTest < DuckHuntTestCase
  test "should create an instance wtesth the provided value" do
    validator = DuckHunt::Validators::LessThan.new(3)
    assert_equal 3, validator.value
  end

  test "should raise an exception if a value is not provided" do
    assert_raises ArgumentError do
      DuckHunt::Validators::LessThan.new
    end
  end

  test "should have the correct error message based on the value provided" do
    validator = DuckHunt::Validators::LessThan.new(3)
    assert_equal "greater than `3`", validator.error_message
  end
end


class DuckHuntLessThanValidationValueTest < DuckHuntTestCase
  def setup
    @validator = DuckHunt::Validators::LessThan.new(3)
  end

  test "returns true if the value provided is less than the value given" do
    assert_equal true, @validator.valid?(2)
    assert_equal true, @validator.valid?(0)
  end

  test "returns false if the value provided is greater than the value provided" do
    assert_equal false, @validator.valid?(3)
    assert_equal false, @validator.valid?(5)
  end
end

class DuckHuntValidationLengthCheckTest < DuckHuntTestCase
  def setup
    @validator = DuckHunt::Validators::LessThan.new(3)
  end

  test "returns true if the value provided is less than the value given" do
    assert_equal true, @validator.valid?("aa")
    assert_equal true, @validator.valid?([1])
    assert_equal true, @validator.valid?({})
    assert_equal true, @validator.valid?("")
  end

  test "returns false if the value provided is greater than the value provided" do
    assert_equal false, @validator.valid?("aaa")
    assert_equal false, @validator.valid?([1,2,3])
    assert_equal false, @validator.valid?("aaaa")
    assert_equal false, @validator.valid?([1,2,3,4,5])
    assert_equal false, @validator.valid?({a: 1, b: 2, c: 3, d: 4})
  end
end