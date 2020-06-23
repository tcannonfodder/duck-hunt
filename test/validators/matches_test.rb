require File.expand_path('../../test_helper', __FILE__)

class DuckHuntMatchesValidatorTest < DuckHuntTestCase
  def setup
    @validator = DuckHunt::Validators::Matches.new(/\d{1,2}/)
  end

  test "should create an instance with the provided regex" do
    validator = DuckHunt::Validators::Matches.new(/\d{1,2}/)
    assert_equal /\d{1,2}/, validator.regex
  end

  test "should raise an exception if a Regex is not provided" do
    assert_raises TypeError do
      DuckHunt::Validators::Matches.new
    end
  end

  test "should accept a string as a valid Regexp" do
    validator = DuckHunt::Validators::Matches.new('\d{1,2}')
    assert_equal /\d{1,2}/, validator.regex
  end

  test "returns true if the value provided matches the regexp" do
    assert_equal true, @validator.valid?("1")
    assert_equal true, @validator.valid?("12")
  end

  test "returns false if the value provided does not match the regexp" do
    assert_equal false, @validator.valid?("hello")
  end

  test "should have the correct error message" do
    validator = DuckHunt::Validators::Matches.new(/\d{1,2}/)
    assert_equal "No matches for Regexp", validator.error_message
  end
end