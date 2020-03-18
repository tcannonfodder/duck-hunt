require File.expand_path('../../test_helper', __FILE__)

describe DuckHunt::Validators::LessThanOrEqualTo, "initialization" do
  it "should create an instance with the provided value" do
    validator = DuckHunt::Validators::LessThanOrEqualTo.new(3)
    validator.value.must_equal 3
  end

  it "should raise an exception if a value is not provided" do
    lambda{
      DuckHunt::Validators::LessThanOrEqualTo.new
    }.must_raise ArgumentError
  end
end

describe DuckHunt::Validators::LessThanOrEqualTo, "Validation" do
  before do
    @validator = DuckHunt::Validators::LessThanOrEqualTo.new(3)
  end

  it "returns true if the value provided is less than or equal to the value given" do
    @validator.valid?(3).must_equal true
    @validator.valid?(2).must_equal true
    @validator.valid?(0).must_equal true
  end

  it "returns false if the value provided is greater than the value provided" do
    @validator.valid?(4).must_equal false
    @validator.valid?(5).must_equal false
  end
end

describe DuckHunt::Validators::LessThanOrEqualTo, "Validation (length check)" do
  before do
    @validator = DuckHunt::Validators::LessThanOrEqualTo.new(3)
  end

  it "returns true if the value provided is less than or equal to the value given" do
    @validator.valid?("aaa").must_equal true
    @validator.valid?([1,2]).must_equal true
    @validator.valid?({}).must_equal true
  end

  it "returns false if the value provided is greater than the value provided" do
    @validator.valid?("aaaa").must_equal false
    @validator.valid?([1,2,3,4,5]).must_equal false
    @validator.valid?({a: 1, b: 2, c: 3, d: 4}).must_equal false
  end
end



describe DuckHunt::Validators::LessThanOrEqualTo, "error message" do
  it "should have the correct error message based on the value provided" do
    validator = DuckHunt::Validators::LessThanOrEqualTo.new(3)
    validator.error_message.must_equal "greater than `3`"
  end
end