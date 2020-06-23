require File.expand_path('../../test_helper', __FILE__)

class DuckHuntBooleanPropertyTest < DuckHuntTestCase
  def setup
    @property = DuckHunt::Properties::Boolean.new
  end

  test "should be able to validate a boolean" do
    assert_equal true, @property.valid?(true)
    assert_equal 0, @property.errors.size

    assert_equal true, @property.valid?(false)
    assert_equal 0, @property.errors.size
  end

  test "should be invalid if there's a type mismatch" do
    assert_equal false, @property.valid?([1,2,3])
    assert_equal 1, @property.errors.size
    assert_equal "wrong type", @property.errors.first
  end

  test "should not be able to validate a string of a boolean" do
    assert_equal false, @property.valid?("true")
    assert_equal 1, @property.errors.size
    assert_equal "wrong type", @property.errors.first
  end

  test "should not be able to validate the integer 'representations' of a boolean" do
    assert_equal false, @property.valid?(0)
    assert_equal 1, @property.errors.size
    assert_equal "wrong type", @property.errors.first

    assert_equal false, @property.valid?(1)
    assert_equal 1, @property.errors.size
    assert_equal "wrong type", @property.errors.first
  end
end