require File.expand_path('../../test_helper', __FILE__)

describe ObjectSchemas::Validators::RejectedValues, "initialization" do
  it "should create an instance with the provided value" do
    validator = ObjectSchemas::Validators::RejectedValues.new([1,2,3])
    validator.values.must_equal [1,2,3]
  end

  it "should raise an exception if a value is not provided" do
    lambda{
      ObjectSchemas::Validators::RejectedValues.new
    }.must_raise ArgumentError
  end

  it "should raise an exception if the value provided is not a hash" do
    lambda{
      ObjectSchemas::Validators::RejectedValues.new(3)
    }.must_raise ArgumentError
  end
end

describe ObjectSchemas::Validators::RejectedValues, "Validation" do
  before do
    @validator = ObjectSchemas::Validators::RejectedValues.new([1,2,3])
  end

  it "returns true if the value provided is not one of the rejected values" do
    @validator.valid?(4).must_equal true
    @validator.valid?(0).must_equal true
  end

  it "returns false if the value provided is one of the rejected values" do
    @validator.valid?(1).must_equal false
    @validator.valid?(2).must_equal false
    @validator.valid?(3).must_equal false
  end
end



describe ObjectSchemas::Validators::RejectedValues, "error message" do
  it "should have the correct error message based on the value provided" do
    validator = ObjectSchemas::Validators::RejectedValues.new([1,2,3])
    validator.error_message.must_equal "a rejected value"
  end
end