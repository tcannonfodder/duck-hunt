require File.expand_path('../../test_helper', __FILE__)

class DuckHuntPropertiesTest < DuckHuntTestCase
  test "should make the property required by default" do
    property = DuckHunt::Properties::Property.new
    assert_equal true, property.required
    assert_equal true, property.required?
  end

  test "should not allow nil objects by default" do
    property = DuckHunt::Properties::Property.new
    assert_equal false, property.allow_nil
    assert_equal false, property.allow_nil?
  end

  test "allow the requiredness to be changed via the options hash" do
    property = DuckHunt::Properties::Property.new(:required => false)
    assert_equal false, property.required
    assert_equal false, property.required?

    property = DuckHunt::Properties::Property.new(:required => true)
    assert_equal true, property.required
    assert_equal true, property.required?
  end

  test "should be invalid if there's a type mismatch" do
    property = DuckHunt::Properties::Property.new
    property.stubs(:matches_type?).returns(false)

    assert_equal false, property.valid?("herp")
    assert_equal 1, property.errors.size
    assert_equal "wrong type", property.errors.first
  end

  test "should not call the validators when there is a type mismatch" do
    property = DuckHunt::Properties::Property.new(:always_wrong => true)
    property.stubs(:matches_type?).returns(false)

    assert_equal false, property.valid?("herp")
    assert_equal 1, property.errors.size
    assert_equal "wrong type", property.errors.first
  end

  test "should raise an exception if a validator raises an exception, since this is the clearest way to indicate the schema was not defined correctly" do
    property = DuckHunt::Properties::Property.new(:always_raise_exception => true)
    property.stubs(:matches_type?).returns(true)

    assert_raises Exception do
      property.valid?("herp")
    end
  end

  test "should use a validator defined during initialization when validating" do
    property = DuckHunt::Properties::Property.new(:always_wrong => true)
    property.stubs(:matches_type?).returns(true)
    assert_equal false, property.valid?("herp")
    assert_equal 1, property.errors.size
    assert_equal "Always Wrong", property.errors.first
  end

  test "should support adding multiple validators during initialization" do
    property = DuckHunt::Properties::Property.new(:always_wrong => true, :wrong_again => true)
    property.stubs(:matches_type?).returns(true)
    assert_equal false, property.valid?("herp")
    assert_equal 2, property.errors.size
    assert_equal ["Always Wrong", "Wrong Again"].to_set, property.errors.to_set
  end

  test "should be valid if the type matches and no validators are added" do
    property = DuckHunt::Properties::Property.new
    property.stubs(:matches_type?).returns(true)

    assert_equal true, property.valid?("herp")
    assert_equal 0, property.errors.size
  end

  test "should be valid if the type matches and all validators pass" do
    property = DuckHunt::Properties::Property.new(:always_right => true, :right_again => true)
    property.stubs(:matches_type?).returns(true)

    assert_equal true, property.valid?("herp")
    assert_equal 0, property.errors.size
  end

  test "should be valid if a nil object is allowed and a nil object is provided" do
    property = DuckHunt::Properties::Property.new(:allow_nil => true)
    assert_equal true, property.valid?(nil)
    assert_equal 0, property.errors.size
  end

  test "should be valid if a nil object is allowed and a nil object is provided, even if there are other validators that would be invalidated" do
    property = DuckHunt::Properties::Property.new(:allow_nil => true, :always_wrong => true)
    assert_equal true, property.valid?(nil)
    assert_equal 0, property.errors.size
  end

  test "should be invalid if a nil object is provided and nil objects are not allowed" do
    property = DuckHunt::Properties::Property.new(:allow_nil => false)
    assert_equal false, property.valid?(nil)
    assert_equal 1, property.errors.size
    assert_equal "nil object not allowed", property.errors.first
  end

  test "should be valid if the type matches and all validators pass (even if a nil object is allowed)" do
    property = DuckHunt::Properties::Property.new(:allow_nil => true, :always_right => true)
    property.stubs(:matches_type?).returns(true)
    assert_equal true, property.valid?("hello")
    assert_equal 0, property.errors.size
  end

  test "should add the 'required' error message if requested" do
    property = DuckHunt::Properties::Property.new
    property.add_required_error
    assert_equal 1, property.errors.size
    assert_equal "required", property.errors.first
  end

  test "should raise NotImplementedError if `matches_type?` has not been defined (subclasses define it)" do
    property = DuckHunt::Properties::Property.new
    assert_raises NotImplementedError do
      property.valid?("hello")
    end
  end
end

class DuckHuntPropertiesValidatingMultipleTimesTest < DuckHuntTestCase
  def setup
    @property = DuckHunt::Properties::Property.new
    @property.stubs(:matches_type?).returns(true)
  end

  test "should ensure that the errors are cleared out each time `valid?` is called" do
    @property.stubs(:matches_type?).returns(false)
    @property.valid?("herp")
    assert_equal 1, @property.errors.size

    @property.stubs(:matches_type?).returns(true)
    @property.valid?("herp")
    assert_equal 0, @property.errors.size
  end

  test "should ensure that a property can go from valid to invalid" do
    assert_equal true, @property.valid?("herp")
    assert_equal 0, @property.errors.size

    @property.stubs(:matches_type?).returns(false)
    assert_equal false, @property.valid?("herp")
    assert_equal 1, @property.errors.size
  end

  test "should ensure that a property can go from invalid to valid" do
    @property.stubs(:matches_type?).returns(false)
    assert_equal false, @property.valid?("herp")
    assert_equal 1, @property.errors.size

    @property.stubs(:matches_type?).returns(true)
    assert_equal true, @property.valid?("herp")
    assert_equal 0, @property.errors.size
  end

  test "should not add the required message twice" do
    @property.stubs(:matches_type?).returns(false)
    @property.add_required_error
    @property.add_required_error
    assert_equal 1, @property.errors.size
    assert_equal ["required"], @property.errors
  end
end

class DuckHuntPropertiesSecurityTest < DuckHuntTestCase
  test "should ensure the required status cannot be modified" do
    property = DuckHunt::Properties::Property.new(:required => true)
    assert_raises NoMethodError do
      property.required = false
    end

    assert_equal true, property.required
  end

  test "should ensure the list of validators cannot be accessed or modified" do
    property = DuckHunt::Properties::Property.new

    assert_raises NoMethodError do
      property.validators["malicious"] = "muwah ha ha"
    end

    assert_raises NoMethodError do
      property.validators = {:malicious => "mwuah ha ha"}
    end
  end
end