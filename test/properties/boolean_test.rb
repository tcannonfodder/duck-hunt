require File.expand_path('../../test_helper', __FILE__)

describe ObjectSchemas::Properties::Boolean, "validation" do
  before do
    @property = ObjectSchemas::Properties::Boolean.new
  end

  it "should be able to validate a boolean" do
    @property.valid?(true).must_equal true
    @property.errors.size.must_equal 0

    @property.valid?(false).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should be invalid if there's a type mismatch" do
    @property.valid?([1,2,3]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors.first.must_equal "wrong type"
  end

  it "should not be able to validate a string of a boolean" do
    @property.valid?("true").must_equal false
    @property.errors.size.must_equal 1
    @property.errors.first.must_equal "wrong type"
  end

  it "should not be able to validate the integer 'representations' of a boolean" do
    @property.valid?(0).must_equal false
    @property.errors.size.must_equal 1
    @property.errors.first.must_equal "wrong type"

    @property.valid?(1).must_equal false
    @property.errors.size.must_equal 1
    @property.errors.first.must_equal "wrong type"
  end
end