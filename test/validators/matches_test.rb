require File.expand_path('../../test_helper', __FILE__)

describe ObjectSchemas::Validators::Matches, "initialization" do
  it "should create an instance with the provided regex" do
    validator = ObjectSchemas::Validators::Matches.new(/\d{1,2}/)
    validator.regex.must_equal /\d{1,2}/
  end

  it "should raise an exception if a Regex is not provided" do
    lambda{
      ObjectSchemas::Validators::Matches.new
    }.must_raise TypeError
  end

  it "should accept a string as a valid Regexp" do
    validator = ObjectSchemas::Validators::Matches.new('\d{1,2}')
    validator.regex.must_equal /\d{1,2}/
  end
end

describe ObjectSchemas::Validators::Matches, "Validation" do
  before do
    @validator = ObjectSchemas::Validators::Matches.new(/\d{1,2}/)
  end

  it "returns true if the value provided matches the regexp" do
    @validator.valid?("1").must_equal true
    @validator.valid?("12").must_equal true
  end

  it "returns false if the value provided does not match the regexp" do
    @validator.valid?("hello").must_equal false
  end
end



describe ObjectSchemas::Validators::Matches, "error message" do
  it "should have the correct error message" do
    validator = ObjectSchemas::Validators::Matches.new(/\d{1,2}/)
    validator.error_message.must_equal "No matches for Regexp"
  end
end