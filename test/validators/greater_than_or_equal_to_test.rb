require File.expand_path('../../test_helper', __FILE__)

describe ObjectSchemas::Validators::GreaterThanOrEqualTo, "initialization" do
  it "should create an instance with the provided value" do
    validator = ObjectSchemas::Validators::GreaterThanOrEqualTo.new(3)
    validator.value.must_equal 3
  end

  it "should raise an exception if a value is not provided" do
    lambda{
      ObjectSchemas::Validators::GreaterThanOrEqualTo.new
    }.must_raise ArgumentError
  end
end

describe ObjectSchemas::Validators::GreaterThanOrEqualTo, "Validation" do
  before do
    @validator = ObjectSchemas::Validators::GreaterThanOrEqualTo.new(3)
  end

  it "returns true if the value provided is greater than or equal to the value given" do
    @validator.valid?(4).must_equal true
    @validator.valid?(41).must_equal true
    @validator.valid?(3).must_equal true
  end

  it "returns false if the value provided is less than the value given" do
    @validator.valid?(0).must_equal false
  end
end



describe ObjectSchemas::Validators::GreaterThanOrEqualTo, "error message" do
  it "should have the correct error message based on the value provided" do
    validator = ObjectSchemas::Validators::GreaterThanOrEqualTo.new(3)
    validator.error_message.must_equal "less than `3`"
  end
end