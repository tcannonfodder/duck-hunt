require File.expand_path('../../test_helper', __FILE__)

describe ObjectSchemas::Properties::Float, "validation" do
  before do
    @property = ObjectSchemas::Properties::Float.new
  end

  it "should be able to validate a float" do
    float = 1.17
    float.must_be_instance_of Float
    @property.valid?(float).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should be able to validate a BigDecimal floating point" do
    bigdecimal = BigDecimal.new("3.4")
    bigdecimal.must_be_instance_of BigDecimal
    @property.valid?(bigdecimal).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should be invalid if there's a type mismatch" do
    @property.valid?([1,2,3]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors.first.must_equal "wrong type"
  end

  it "should not be validate to parse a Fixnum" do
    integer = 3
    integer.must_be_instance_of Fixnum
    @property.valid?(integer).must_equal false
    @property.errors.size.must_equal 1
    @property.errors.first.must_equal "wrong type"
  end

  it "should not be able to validate a Bignum" do
    integer = 18446744073709551616
    integer.must_be_instance_of Bignum
    @property.valid?(integer).must_equal false
    @property.errors.size.must_equal 1
    @property.errors.first.must_equal "wrong type"
  end

  it "should not be able to validate a string of an float" do
    @property.valid?("3.17").must_equal false
    @property.errors.size.must_equal 1
    @property.errors.first.must_equal "wrong type"
  end
end