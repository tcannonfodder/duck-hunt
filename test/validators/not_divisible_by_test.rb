require File.expand_path('../../test_helper', __FILE__)

describe ObjectSchemas::Validators::NotDivisibleBy, "initialization" do
  it "should create an instance with the provided value" do
    validator = ObjectSchemas::Validators::NotDivisibleBy.new(3)
    validator.value.must_equal 3
  end

  it "should raise an exception if a value is not provided" do
    lambda{
      ObjectSchemas::Validators::NotDivisibleBy.new
    }.must_raise ArgumentError
  end
end

describe ObjectSchemas::Validators::NotDivisibleBy, "Validation" do
  before do
    @validator = ObjectSchemas::Validators::NotDivisibleBy.new(3)
  end

  it "returns true if the value provided is not divisible by the value provided" do
    @validator.valid?(5).must_equal true
  end

  it "returns false if the value provided is divisible by to the value given" do
    @validator.valid?(3).must_equal false
    @validator.valid?(9).must_equal false
  end
end



describe ObjectSchemas::Validators::NotDivisibleBy, "error message" do
  it "should have the correct error message based on the value provided" do
    validator = ObjectSchemas::Validators::NotDivisibleBy.new(3)
    validator.error_message.must_equal "divisible by `3`"
  end
end