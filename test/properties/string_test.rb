require File.expand_path('../../test_helper', __FILE__)

describe ObjectSchemas::Properties::String, "validation" do
  before do
    @property = ObjectSchemas::Properties::String.new
  end

  it "should be able to validate a string" do
    @property.valid?("herpderp").must_equal true
    @property.errors.size.must_equal 0
  end

  it "should be invalid if there's a type mismatch" do
    @property.valid?([1,2,3]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors.first.must_equal "wrong type"
  end

  it "should not be able to validate a symbol" do
    @property.valid?(:test).must_equal false
    @property.errors.size.must_equal 1
    @property.errors.first.must_equal "wrong type"
  end
end