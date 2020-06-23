require File.expand_path('../../test_helper', __FILE__)

class DuckHuntStringPropertyTest < DuckHuntTestCase
  def setup
    @property = DuckHunt::Properties::String.new
  end

  test "should be able to validate a string" do
    assert_equal true, @property.valid?("herpderp")
    assert_equal 0, @property.errors.size
  end

  test "should be invalid if there's a type mismatch" do
    assert_equal false, @property.valid?([1,2,3])
    assert_equal 1, @property.errors.size
    assert_equal "wrong type", @property.errors.first
  end

  test "should not be able to validate a symbol" do
    assert_equal false, @property.valid?(:test)
    assert_equal 1, @property.errors.size
    assert_equal "wrong type", @property.errors.first
  end
end