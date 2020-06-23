require File.expand_path('../../test_helper', __FILE__)

class DuckHuntFloatPropertyTest < DuckHuntTestCase
  def setup
    @property = DuckHunt::Properties::Float.new
  end

  test "should be able to validate a float" do
    float = 1.17
    assert_instance_of Float, float
    assert_equal true, @property.valid?(float)
    assert_equal 0, @property.errors.size
  end

  test "should be able to validate a BigDecimal floating point" do
    bigdecimal = BigDecimal("3.4")
    assert_instance_of BigDecimal, bigdecimal
    assert_equal true, @property.valid?(bigdecimal)
    assert_equal 0, @property.errors.size
  end

  test "should be invalid if there's a type mismatch" do
    assert_equal false, @property.valid?([1,2,3])
    assert_equal 1, @property.errors.size
    assert_equal "wrong type", @property.errors.first
  end

  test "should not be validate to parse a Fixnum" do
    integer = 3
    assert_instance_of Fixnum, integer
    assert_equal false, @property.valid?(integer)
    assert_equal 1, @property.errors.size
    assert_equal "wrong type", @property.errors.first
  end

  test "should not be able to validate a Bignum" do
    integer = 18446744073709551616
    assert_instance_of Bignum, integer
    assert_equal false, @property.valid?(integer)
    assert_equal 1, @property.errors.size
    assert_equal "wrong type", @property.errors.first
  end

  test "should not be able to validate a string of an float" do
    assert_equal false, @property.valid?("3.17")
    assert_equal 1, @property.errors.size
    assert_equal "wrong type", @property.errors.first
  end
end