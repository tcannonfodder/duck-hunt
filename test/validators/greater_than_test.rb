require File.expand_path('../../test_helper', __FILE__)

describe DuckHunt::Validators::GreaterThan, "initialization" do
  it "should create an instance with the provided value" do
    validator = DuckHunt::Validators::GreaterThan.new(3)
    validator.value.must_equal 3
  end

  it "should raise an exception if a value is not provided" do
    lambda{
      DuckHunt::Validators::GreaterThan.new
    }.must_raise ArgumentError
  end
end

describe DuckHunt::Validators::GreaterThan, "Validation" do
  before do
    @validator = DuckHunt::Validators::GreaterThan.new(3)
  end

  it "returns true if the value provided is greater than the value given" do
    @validator.valid?(4).must_equal true
    @validator.valid?(41).must_equal true
  end

  it "returns false if the value provided is less than the value provided" do
    @validator.valid?(3).must_equal false
    @validator.valid?(0).must_equal false
  end
end

describe DuckHunt::Validators::GreaterThan, "Validation (length check)" do
  before do
    @validator = DuckHunt::Validators::GreaterThan.new(3)
  end

  it "returns true if the value provided is greater than the value given" do
    @validator.valid?("aaaa").must_equal true
    @validator.valid?([1,2,3,4]).must_equal true
    @validator.valid?({a: 1, b: 2, c: 3, d: 4}).must_equal true
  end

  it "returns false if the value provided is less than the value given" do
    @validator.valid?("aaa").must_equal false
    @validator.valid?([1,2,3]).must_equal false
    @validator.valid?({a: 1, b: 2, c: 3}).must_equal false
    @validator.valid?({}).must_equal false
    @validator.valid?("").must_equal false
  end
end


describe DuckHunt::Validators::GreaterThan, "error message" do
  it "should have the correct error message based on the value provided" do
    validator = DuckHunt::Validators::GreaterThan.new(3)
    validator.error_message.must_equal "less than `3`"
  end
end