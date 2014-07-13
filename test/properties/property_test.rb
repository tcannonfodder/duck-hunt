require File.expand_path('../../test_helper', __FILE__)

describe DuckHunt::Properties::Property, "initialization" do
  it "should make the property required by default" do
    property = DuckHunt::Properties::Property.new
    property.required.must_equal true
    property.required?.must_equal true
  end

  it "should not allow nil objects by default" do
    property = DuckHunt::Properties::Property.new
    property.allow_nil.must_equal false
    property.allow_nil?.must_equal false
  end

  it "allow the requiredness to be changed via the options hash" do
    property = DuckHunt::Properties::Property.new(:required => false)
    property.required.must_equal false
    property.required?.must_equal false

    property = DuckHunt::Properties::Property.new(:required => true)
    property.required.must_equal true
    property.required?.must_equal true
  end
end

describe DuckHunt::Properties::Property, "validation" do
  it "should be invalid if there's a type mismatch" do
    property = DuckHunt::Properties::Property.new
    property.stubs(:matches_type?).returns(false)

    property.valid?("herp").must_equal false
    property.errors.size.must_equal 1
    property.errors.first.must_equal "wrong type"
  end

  it "should not call the validators when there is a type mismatch" do
    property = DuckHunt::Properties::Property.new(:always_wrong => true)
    property.stubs(:matches_type?).returns(false)

    property.valid?("herp").must_equal false
    property.errors.size.must_equal 1
    property.errors.first.must_equal "wrong type"
  end

  it "should raise an exception if a validator raises an exception, since this is the clearest way to indicate the schema was not defined correctly" do
    property = DuckHunt::Properties::Property.new(:always_raise_exception => true)
    property.stubs(:matches_type?).returns(true)

    lambda{
      property.valid?("herp")
    }.must_raise Exception
  end

  it "should use a validator defined during initialization when validating" do
    property = DuckHunt::Properties::Property.new(:always_wrong => true)
    property.stubs(:matches_type?).returns(true)
    property.valid?("herp").must_equal false
    property.errors.size.must_equal 1
    property.errors.first.must_equal "Always Wrong"
  end

  it "should support adding multiple validators during initialization" do
    property = DuckHunt::Properties::Property.new(:always_wrong => true, :wrong_again => true)
    property.stubs(:matches_type?).returns(true)
    property.valid?("herp").must_equal false
    property.errors.size.must_equal 2
    property.errors.to_set.must_equal ["Always Wrong", "Wrong Again"].to_set
  end

  it "should be valid if the type matches and no validators are added" do
    property = DuckHunt::Properties::Property.new
    property.stubs(:matches_type?).returns(true)

    property.valid?("herp").must_equal true
    property.errors.size.must_equal 0
  end

  it "should be valid if the type matches and all validators pass" do
    property = DuckHunt::Properties::Property.new(:always_right => true, :right_again => true)
    property.stubs(:matches_type?).returns(true)

    property.valid?("herp").must_equal true
    property.errors.size.must_equal 0
  end

  it "should be valid if a nil object is allowed and a nil object is provided" do
    property = DuckHunt::Properties::Property.new(:allow_nil => true)
    property.valid?(nil).must_equal true
    property.errors.size.must_equal 0
  end

  it "should be valid if a nil object is allowed and a nil object is provided, even if there are other validators that would be invalidated" do
    property = DuckHunt::Properties::Property.new(:allow_nil => true, :always_wrong => true)
    property.valid?(nil).must_equal true
    property.errors.size.must_equal 0
  end

  it "should be invalid if a nil object is provided and nil objects are not allowed" do
    property = DuckHunt::Properties::Property.new(:allow_nil => false)
    property.valid?(nil).must_equal false
    property.errors.size.must_equal 1
    property.errors.first.must_equal "nil object not allowed"
  end

  it "should be valid if the type matches and all validators pass (even if a nil object is allowed)" do
    property = DuckHunt::Properties::Property.new(:allow_nil => true, :always_right => true)
    property.stubs(:matches_type?).returns(true)
    property.valid?("hello").must_equal true
    property.errors.size.must_equal 0
  end

  it "should add the 'required' error message if requested" do
    property = DuckHunt::Properties::Property.new
    property.add_required_error
    property.errors.size.must_equal 1
    property.errors.first.must_equal "required"
  end

  it "should raise NotImplementedError if `matches_type?` has not been defined (subclasses define it)" do
    property = DuckHunt::Properties::Property.new
    lambda{
      property.valid?("hello")
    }.must_raise(NotImplementedError)
  end
end

describe DuckHunt::Properties::Property, "validating multiple times" do
  before do
    @property = DuckHunt::Properties::Property.new
    @property.stubs(:matches_type?).returns(true)
  end

  it "should ensure that the errors are cleared out each time `valid?` is called" do
    @property.stubs(:matches_type?).returns(false)
    @property.valid?("herp")
    @property.errors.size.must_equal 1

    @property.stubs(:matches_type?).returns(true)
    @property.valid?("herp")
    @property.errors.size.must_equal 0
  end

  it "should ensure that a property can go from valid to invalid" do
    @property.valid?("herp").must_equal true
    @property.errors.size.must_equal 0

    @property.stubs(:matches_type?).returns(false)
    @property.valid?("herp").must_equal false
    @property.errors.size.must_equal 1
  end

  it "should ensure that a property can go from invalid to valid" do
    @property.stubs(:matches_type?).returns(false)
    @property.valid?("herp").must_equal false
    @property.errors.size.must_equal 1

    @property.stubs(:matches_type?).returns(true)
    @property.valid?("herp").must_equal true
    @property.errors.size.must_equal 0
  end

  it "should not add the required message twice" do
    @property.stubs(:matches_type?).returns(false)
    @property.add_required_error
    @property.add_required_error
    @property.errors.size.must_equal 1
    @property.errors.must_equal ["required"]
  end
end

describe DuckHunt::Properties::Property, "security" do
  it "should ensure the required status cannot be modified" do
    property = DuckHunt::Properties::Property.new(:required => true)
    lambda{
      property.required = false
    }.must_raise(NoMethodError)

    property.required.must_equal true
  end

  it "should ensure the list of validators cannot be accessed or modified" do
    property = DuckHunt::Properties::Property.new

    lambda{
      property.validators["malicious"] = "muwah ha ha"
    }.must_raise(NoMethodError)

    lambda{
      property.validators = {:malicious => "mwuah ha ha"}
    }.must_raise(NoMethodError)
  end
end