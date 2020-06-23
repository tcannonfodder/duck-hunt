require File.expand_path('../../test_helper', __FILE__)

class DuckHuntNilPropertyTest < DuckHuntTestCase
  def setup
    @property = DuckHunt::Properties::Nil.new
  end

  test "should be able to validate a nil value" do
    assert_equal true, @property.valid?(nil)
    assert_equal 0, @property.errors.size
  end

  test "should be invalid if the value is not nil" do
    assert_equal false, @property.valid?([1,2,3])
    assert_equal 1, @property.errors.size
    assert_equal "wrong type", @property.errors.first
  end

  test "should not be able to validate a string representing nil" do
    assert_equal false, @property.valid?("nil")
    assert_equal 1, @property.errors.size
    assert_equal "wrong type", @property.errors.first
  end

  test "should not be able to validate the integer 'representation' of a nil" do
    assert_equal false, @property.valid?(0)
    assert_equal 1, @property.errors.size
    assert_equal "wrong type", @property.errors.first
  end
end