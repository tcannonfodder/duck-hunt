require File.expand_path('../../test_helper', __FILE__)

describe ObjectSchemas::Properties::Property, "initialization" do
  it "should require a name" do
    lambda{
      ObjectSchemas::Properties::Property.new(nil)
    }.must_raise(ArgumentError)

    lambda{
      ObjectSchemas::Properties::Property.new("")
    }.must_raise(ArgumentError)
  end

  it "should store the name provided" do
     property = ObjectSchemas::Properties::Property.new("test")
     property.name.must_equal "test"
  end

  it "should make the property required by default" do
    property = ObjectSchemas::Properties::Property.new("test")
    property.required.must_equal true
    property.required?.must_equal true
  end

  it "allow the requiredness to be changed via the options hash" do
    property = ObjectSchemas::Properties::Property.new("test", :required => false)
    property.required.must_equal false
    property.required?.must_equal false

    property = ObjectSchemas::Properties::Property.new("test", :required => true)
    property.required.must_equal true
    property.required?.must_equal true
  end
end

describe ObjectSchemas::Properties::Property, "validation" do
  it "should be invalid if there's a type mismatch" do
    property = ObjectSchemas::Properties::Property.new("test")
    property.stubs(:matches_type?).returns(false)

    property.valid?("herp").must_equal false
    property.errors.size.must_equal 1
    property.errors.first.must_equal "does not match type"
  end

  it "should use a validator defined during initialization when validating" do
    property = ObjectSchemas::Properties::Property.new("test", :always_wrong => true)
    property.stubs(:matches_type?).returns(true)
    property.valid?("herp").must_equal false
    property.errors.size.must_equal 1
    property.errors.first.must_equal "Always Wrong"
  end

  it "should support adding multiple validators during initialization" do
    property = ObjectSchemas::Properties::Property.new("test", :always_wrong => true, :wrong_again => true)
    property.stubs(:matches_type?).returns(true)
    property.valid?("herp").must_equal false
    property.errors.size.must_equal 2
    property.errors.to_set == ["Always Wrong", "Wrong Again"].to_set
  end

  it "should be valid if the type matches and no validators are added" do
    property = ObjectSchemas::Properties::Property.new("test")
    property.stubs(:matches_type?).returns(true)

    property.valid?("herp").must_equal true
    property.errors.size.must_equal 0
  end

  it "should be valid if the type matches and all validators pass" do
    property = ObjectSchemas::Properties::Property.new("test", :always_right => true, :right_again => true)
    property.stubs(:matches_type?).returns(true)

    property.valid?("herp").must_equal true
    property.errors.size.must_equal 0
  end

  it "should add the 'required' error message if requested" do
    property = ObjectSchemas::Properties::Property.new("test")
    property.add_required_error
    property.errors.size.must_equal 1
    property.errors.first.must_equal "required"
  end

  it "should raise NotImplementedError if `matches_type?` has not been defined (subclasses define it)" do
    property = ObjectSchemas::Properties::Property.new("test")
    lambda{
      property.valid?("hello")
    }.must_raise(NotImplementedError)
  end
end

describe ObjectSchemas::Properties::Property, "validating multiple times" do
  before do
    @property = ObjectSchemas::Properties::Property.new("test")
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
end

describe ObjectSchemas::Properties::Property, "security" do
  it "should ensure the name cannot be modified" do
    property = ObjectSchemas::Properties::Property.new("test")
    lambda{
      property.name = "herp"
    }.must_raise(NoMethodError)

    property.name.must_equal "test"
  end

  it "should ensure the required status cannot be modified" do
    property = ObjectSchemas::Properties::Property.new("test", :required => true)
    lambda{
      property.required = false
    }.must_raise(NoMethodError)

    property.required.must_equal true
  end

  it "should ensure the list of validators cannot be accessed or modified" do
    property = ObjectSchemas::Properties::Property.new("test")

    lambda{
      property.validators["malicious"] = "muwah ha ha"
    }.must_raise(NoMethodError)

    lambda{
      property.validators = {:malicious => "mwuah ha ha"}
    }.must_raise(NoMethodError)
  end
end