require File.expand_path('../../test_helper', __FILE__)

describe DuckHunt::Validators::AllowBlank, "initialization" do
  it "should create an instance with the provided value" do
    validator = DuckHunt::Validators::AllowBlank.new(true)
    validator.value.must_equal true
  end

  it "should raise an exception if a value is not provided" do
    lambda{
      DuckHunt::Validators::AllowBlank.new
    }.must_raise ArgumentError
  end
end

describe DuckHunt::Validators::AllowBlank, "Validation (allow blank)" do
  before do
    @validator = DuckHunt::Validators::AllowBlank.new(true)
  end

  it "returns true if the value provided is empty" do
    @validator.valid?("").must_equal true
  end

  it "returns true if the value provided is only whitespace" do
    @validator.valid?("   \t\t\n").must_equal true
  end

  it "returns true if the value provided is only weird whitespace" do
    @validator.valid?("\t\n\v\f\r   ᠎               　").must_equal true
  end

  it "returns true if the value provided is not blank" do
    @validator.valid?("abcde").must_equal true
  end
end

describe DuckHunt::Validators::AllowBlank, "Validation (don't allow blank)" do
  before do
    @validator = DuckHunt::Validators::AllowBlank.new(false)
  end

  it "returns false if the value provided is empty" do
    @validator.valid?("").must_equal false
  end

  it "returns false if the value provided is only whitespace" do
    @validator.valid?("   \t\t\n").must_equal false
  end

  it "returns false if the value provided is only weird whitespace" do
    @validator.valid?("\t\n\v\f\r   ᠎               　").must_equal false
  end

  it "returns true if the value provided is not blank" do
    @validator.valid?("abcde").must_equal true
  end
end



describe DuckHunt::Validators::AllowBlank, "error message" do
  it "should have the correct error message based on the value provided" do
    validator = DuckHunt::Validators::AllowBlank.new(false)
    validator.error_message.must_equal "blank values not allowed"
  end
end