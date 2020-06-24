require File.expand_path('../../test_helper', __FILE__)

class DuckHuntAllowBlanksValidatorTest < DuckHuntTestCase
  test "should create an instance with the provided value" do
    validator = DuckHunt::Validators::AllowBlank.new(true)
    assert_equal true, validator.value
  end

  test "should raise an exception if a value is not provided" do
    assert_raises ArgumentError do
      DuckHunt::Validators::AllowBlank.new
    end
  end
end

class DuckHuntAllowBlankValidatorAllowBlankTest < DuckHuntTestCase
  def setup
    @validator = DuckHunt::Validators::AllowBlank.new(true)
  end

  test "returns true if the value provided is empty" do
    assert_equal true, @validator.valid?("")
  end

  test "returns true if the value provided is only whitespace" do
    assert_equal true, @validator.valid?("   \t\t\n")
  end

  test "returns true if the value provided is only weird whitespace" do
    assert_equal true, @validator.valid?("\t\n\v\f\r   ᠎               　")
  end

  test "returns true if the value provided is not blank" do
    assert_equal true, @validator.valid?("abcde")
  end
end

class DuckHuntAllowBlankValidatorDoNotAllowBlankTest < DuckHuntTestCase
  def setup
    @validator = DuckHunt::Validators::AllowBlank.new(false)
  end

  test "returns false if the value provided is empty" do
    assert_equal false, @validator.valid?("")
  end

  test "returns false if the value provided is only whitespace" do
    assert_equal false, @validator.valid?("   \t\t\n")
  end

  test "returns false if the value provided is only weird whitespace" do
    assert_equal false, @validator.valid?("\t\n\v\f\r   ᠎               　")
  end

  test "returns true if the value provided is not blank" do
    assert_equal true, @validator.valid?("abcde")
  end

  test "returns true if the value provided contains whitespace" do
    assert_equal true, @validator.valid?("abcde fghjik\tlmnop\t\tqrst")
  end

  test "should have the correct error message based on the value provided" do
    validator = DuckHunt::Validators::AllowBlank.new(false)
    assert_equal "blank values not allowed", validator.error_message
  end
end