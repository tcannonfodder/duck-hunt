require File.expand_path('../../test_helper', __FILE__)

describe DuckHunt::Properties::Integer, "validation" do
  before do
    @property = DuckHunt::Properties::Integer.new
  end
  it "should be invalid if there's a type mismatch" do
    @property.valid?([1,2,3]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors.first.must_equal "wrong type"
  end

  it "should be able to parse a Fixnum" do
    integer = 3
    integer.must_be_instance_of Fixnum
    @property.valid?(integer).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should be able to parse a Bignum" do
    integer = 18446744073709551616
    integer.must_be_instance_of Bignum
    @property.valid?(integer).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should not be able to parse a string of an integer" do
    @property.valid?("3").must_equal false
    @property.errors.size.must_equal 1
    @property.errors.first.must_equal "wrong type"
  end

  it "should not be able to parse a float" do
    float = 1.17
    float.must_be_instance_of Float
    @property.valid?(float).must_equal false
    @property.errors.size.must_equal 1
    @property.errors.first.must_equal "wrong type"
  end

  it "should not be able to parse a BigDecimal floating point" do
    bigdecimal = BigDecimal("3.4")
    bigdecimal.must_be_instance_of BigDecimal
    @property.valid?(bigdecimal).must_equal false
    @property.errors.size.must_equal 1
    @property.errors.first.must_equal "wrong type"
  end
end