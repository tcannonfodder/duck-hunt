require File.expand_path('../../test_helper', __FILE__)

describe DuckHunt::Validators::AllowEmpty, "initialization" do
  it "should create an instance with the provided value" do
    validator = DuckHunt::Validators::AllowEmpty.new(true)
    validator.value.must_equal true
  end

  it "should raise an exception if a value is not provided" do
    lambda{
      DuckHunt::Validators::AllowEmpty.new
    }.must_raise ArgumentError
  end
end

describe DuckHunt::Validators::AllowEmpty, "Validation (allow empty)" do
  before do
    @validator = DuckHunt::Validators::AllowEmpty.new(true)
  end

  it "returns true if the value provided is empty" do
    @validator.valid?([]).must_equal true
    @validator.valid?("").must_equal true
  end

  it "returns true if the value provided is not empty" do
    @validator.valid?([1,2,3]).must_equal true
    @validator.valid?("abcde").must_equal true
  end
end

describe DuckHunt::Validators::AllowEmpty, "Validation (don't allow empty)" do
  before do
    @validator = DuckHunt::Validators::AllowEmpty.new(false)
  end

  it "returns false if the value provided is empty" do
    @validator.valid?([]).must_equal false
    @validator.valid?("").must_equal false
  end

  it "returns true if the value provided is not empty" do
    @validator.valid?([1,2,3]).must_equal true
    @validator.valid?("abcde").must_equal true
  end
end



describe DuckHunt::Validators::AllowEmpty, "error message" do
  it "should have the correct error message based on the value provided" do
    validator = DuckHunt::Validators::AllowEmpty.new(false)
    validator.error_message.must_equal "empty values not allowed"
  end
end