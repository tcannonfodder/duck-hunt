require File.expand_path('../../test_helper', __FILE__)

class DuckHuntIntegerPropertyTest < DuckHuntTestCase
  def setup
    @property = DuckHunt::Properties::Integer.new
  end

  test "should be invalid if there's a type mismatch" do
    assert_equal false, @property.valid?([1,2,3])
    assert_equal 1, @property.errors.size
    assert_equal "wrong type", @property.errors.first
  end

  test "should be able to parse a Fixnum" do
    integer = 3
    assert_instance_of Fixnum, integer
    assert_equal true, @property.valid?(integer)
    assert_equal 0, @property.errors.size
  end

  test "should be able to parse a Bignum" do
    integer = 18446744073709551616
    assert_instance_of Bignum, integer
    assert_equal true, @property.valid?(integer)
    assert_equal 0, @property.errors.size
  end

  test "should not be able to parse a string of an integer" do
    assert_equal false, @property.valid?("3")
    assert_equal 1, @property.errors.size
    assert_equal "wrong type", @property.errors.first
  end

  test "should not be able to parse a float" do
    float = 1.17
    assert_instance_of Float, float
    assert_equal false, @property.valid?(float)
    assert_equal 1, @property.errors.size
    assert_equal "wrong type", @property.errors.first
  end

  test "should not be able to parse a BigDecimal floating point" do
    bigdecimal = BigDecimal("3.4")
    assert_instance_of BigDecimal, bigdecimal
    assert_equal false, @property.valid?(bigdecimal)
    assert_equal 1, @property.errors.size
    assert_equal "wrong type", @property.errors.first
  end
end