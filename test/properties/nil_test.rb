require File.expand_path('../../test_helper', __FILE__)

describe DuckHunt::Properties::Nil, "validation" do
  before do
    @property = DuckHunt::Properties::Nil.new
  end

  it "should be able to validate a nil value" do
    @property.valid?(nil).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should be invalid if the value is not nil" do
    @property.valid?([1,2,3]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors.first.must_equal "wrong type"
  end

  it "should not be able to validate a string representing nil" do
    @property.valid?("nil").must_equal false
    @property.errors.size.must_equal 1
    @property.errors.first.must_equal "wrong type"
  end

  it "should not be able to validate the integer 'representation' of a nil" do
    @property.valid?(0).must_equal false
    @property.errors.size.must_equal 1
    @property.errors.first.must_equal "wrong type"
  end
end