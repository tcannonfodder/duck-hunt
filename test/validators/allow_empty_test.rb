require File.expand_path('../../test_helper', __FILE__)

class DuckHuntValidatorsAllowEmptyTest < DuckHuntTestCase
  test "should create an instance with the provided value" do
    validator = DuckHunt::Validators::AllowEmpty.new(true)
    assert_equal true, validator.value
  end

  test "should raise an exception if a value is not provided" do
    assert_raises ArgumentError do
      DuckHunt::Validators::AllowEmpty.new
    end
  end
end

class DuckHuntValidatorsAllowEmptyAllowEmptyTest < DuckHuntTestCase
  def setup
    @validator = DuckHunt::Validators::AllowEmpty.new(true)
  end

  test "returns true if the value provided is empty" do
    assert_equal true, @validator.valid?([])
    assert_equal true, @validator.valid?("")
  end

  test "returns true if the value provided is not empty" do
    assert_equal true, @validator.valid?([1,2,3])
    assert_equal true, @validator.valid?("abcde")
  end
end

class DuckHuntValidatorsAllowEmptyDoNotAllowEmptyTest < DuckHuntTestCase
  def setup
    @validator = DuckHunt::Validators::AllowEmpty.new(false)
  end

  test "returns false if the value provided is empty" do
    assert_equal false, @validator.valid?([])
    assert_equal false, @validator.valid?("")
  end

  test "returns true if the value provided is not empty" do
    assert_equal true, @validator.valid?([1,2,3])
    assert_equal true, @validator.valid?("abcde")
  end

  test "should have the correct error message based on the value provided" do
    validator = DuckHunt::Validators::AllowEmpty.new(false)
    assert_equal "empty values not allowed", validator.error_message
  end
end