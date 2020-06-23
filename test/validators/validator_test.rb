require_relative '../test_helper'
require 'byebug'

class DuckHuntValidatorTests < DuckHuntTestCase
  test "should allow an instance to be created with any number of arguments" do
    DuckHunt::Validators::Validator.new("hello", "world")
  end

  test "raises NotImplementedError if valid? has not been defined" do
    validator = DuckHunt::Validators::Validator.new
    assert_raises NotImplementedError do
      validator.valid?("test")
    end
  end

  test "raise NotImplementedError if valid? has not been defined" do
    validator = DuckHunt::Validators::Validator.new
    assert_raises NotImplementedError do
      validator.error_message
    end
  end
end