require File.expand_path('../../test_helper', __FILE__)

class DuckHuntNestedHashPropertyInitializedWithBlockTest < DuckHuntTestCase
  test "should be able to set the property to required" do
    property = DuckHunt::Properties::NestedHash.new :required => true do |s|
      s.test "name"
    end
    assert_equal true, property.required
    assert_equal true, property.required?
  end

  test "should be able to define the property" do
    property = DuckHunt::Properties::NestedHash.new :required => true do |s|
      s.test "name"
    end

    assert_instance_of DuckHunt::Properties::Test, property.properties["name"]
  end

  test "should be able to set options for the property" do
    property = DuckHunt::Properties::NestedHash.new :strict_mode => false do |s|
      s.test "name"
    end

    assert_equal false, property.strict_mode?
  end

  test "should be able to set property-level and property-level options at the same time" do
    property = DuckHunt::Properties::NestedHash.new :required => true, :strict_mode => false do |s|
      s.test "name"
    end
    assert_equal true, property.required
    assert_equal true, property.required?
    assert_equal false, property.strict_mode?
  end

  test "should default the `strict mode` to `true`" do
    property = DuckHunt::Properties::NestedHash.new do |s|
    end

    assert_equal true, property.strict_mode
    assert_equal true, property.strict_mode?
  end

end

class DuckHuntNestedHashPropertyInitializedWithoutBlockTest < DuckHuntTestCase
  test "should raise an exception if a block is not provided" do
    assert_raises ArgumentError do
     DuckHunt::Properties::NestedHash.new :required => false
    end
  end
end

class DuckHuntNestedHashDefiningPropertiesTest < DuckHuntTestCase
  test "should be able to add a new property to the property, which is required by default" do
    property = DuckHunt::Properties::NestedHash.new do |s|
      s.test "name"
    end

    assert_equal 1, property.properties.size
    assert_not_nil property.properties["name"]
    assert_equal true, property.properties["name"].required
    assert_equal true, property.properties["name"].required?
  end

  test "should allow a property to be explictly set as required" do
    property = DuckHunt::Properties::NestedHash.new do |s|
      s.test "name", :required => true
      s.test "item", "required" => true
    end

    assert_equal 2, property.properties.size

    assert_not_nil property.properties["name"]
    assert_equal true, property.properties["name"].required
    assert_equal true, property.properties["name"].required?
    assert_not_nil property.properties["item"]
    assert_equal true, property.properties["item"].required
    assert_equal true, property.properties["item"].required?
  end

  test "should allow a property to be set as not required" do
    property = DuckHunt::Properties::NestedHash.new do |s|
      s.test "name", :required => false
      s.test "item", "required" => false
    end

    assert_equal 2, property.properties.size
    assert_not_nil property.properties["name"]
    assert_equal false, property.properties["name"].required
    assert_equal false, property.properties["name"].required?
    assert_not_nil property.properties["item"]
    assert_equal false, property.properties["item"].required
    assert_equal false, property.properties["item"].required?
  end

  test "should require that properties are named" do
    assert_raises ArgumentError do
      DuckHunt::Properties::NestedHash.new do |s|
        s.test
      end
    end

    assert_raises ArgumentError do
      DuckHunt::Properties::NestedHash.new do |s|
        s.test ""
      end
    end
  end


  test "should prevent a property from being defined multiple times in a property" do
    assert_raises DuckHunt::PropertyAlreadyDefined do
      property = DuckHunt::Properties::NestedHash.new do |s|
        s.test "name"
        s.test "name"
      end
    end
  end

  test "should ensure the list of properties cannot be modified" do
    property = DuckHunt::Properties::NestedHash.new do |s|
      s.test "name"
    end

    assert_equal 1, property.properties.size

    property.properties["malicious"] = "muwah ha ha"
    assert_equal 1, property.properties.size

    assert_raises NoMethodError do
      property.properties = {:malicious => "mwuah ha ha"}
    end
  end

  test "should ensure the list of required properties cannot be modified" do
    property = DuckHunt::Properties::NestedHash.new do |s|
      s.test "name"
    end

    assert_raises NoMethodError do
      property.required_properties = {:malicious => "mwuah ha ha"}
    end
  end
end

class DuckHuntNestedHashStrictModeValidationTest < DuckHuntTestCase
  test "should return false if the object provided is not a hash" do
    property = DuckHunt::Properties::NestedHash.new do |s|
      s.test "name"
    end

    assert_equal false, property.valid?("hello")
    assert_equal 1, property.errors.size
    assert_equal ["wrong type"], property.errors["base"]
  end

  test "should return false if one of the properties is not valid" do
    property = DuckHunt::Properties::NestedHash.new do |s|
      s.always_wrong_type "name"
    end

    assert_equal false, property.valid?({:name => "hello"})
    assert_equal 1, property.errors.size
    assert_equal ["wrong type"], property.errors["name"]
  end

  test "should return false if the object is missing a required property" do
    property = DuckHunt::Properties::NestedHash.new do |s|
      s.test "name", :required => true
      s.always_right_type "hello", :required => false
    end

    assert_equal false, property.valid?({:hello => "hello"})
    assert_equal 1, property.errors.size
    assert_equal ["required"], property.errors["name"]
  end

  test "should return false if the property has been set to strict mode and the hash provided has extra properties" do
    property = DuckHunt::Properties::NestedHash.new do |s|
      s.test "name", :required => true
    end

    assert_equal false, property.valid?({:name => "hello", :hello => "hello"})
    assert_equal 1, property.errors.size
    assert_equal ["has properties not defined in schema"], property.errors["base"]
  end
end

class DuckHuntNestedHashRelaxedModeValidationTest < DuckHuntTestCase
  test "should return false if the object provided is not a hash" do
    property = DuckHunt::Properties::NestedHash.new :strict_mode => false do |s|
      s.test "name"
    end

    assert_equal false, property.valid?("hello")
    assert_equal 1, property.errors.size
    assert_equal ["wrong type"], property.errors["base"]
  end

  test "should return false if one of the properties is not valid" do
    property = DuckHunt::Properties::NestedHash.new :strict_mode => false do |s|
      s.always_wrong_type "name"
    end

    assert_equal false, property.valid?({:name => "hello"})
    assert_equal 1, property.errors.size
    assert_equal ["wrong type"], property.errors["name"]
  end

  test "should return false if the object is missing a required property" do
    property = DuckHunt::Properties::NestedHash.new :strict_mode => false do |s|
      s.test "name", :required => true
      s.always_right_type "hello", :required => false
    end

    assert_equal false, property.valid?({:hello => "hello"})
    assert_equal 1, property.errors.size
    assert_equal ["required"], property.errors["name"]
  end

  test "should return true if the property has been set to relaxed mode and the hash provided has extra properties" do
    property = DuckHunt::Properties::NestedHash.new :strict_mode => false do |s|
      s.always_right_type "name", :required => true
    end

    assert_equal true, property.valid?({:name => "hello", :hello => "hello"})
    assert_equal 0, property.errors.size
  end
end

class DuckHuntNestedHashAllowNilValidationTest < DuckHuntTestCase
  test "should return false if nil is not allowed and a nil object is given" do
    property = DuckHunt::Properties::NestedHash.new :allow_nil => false do |s|
      s.test "name"
    end
    assert_equal false, property.valid?(nil)
    assert_equal 1, property.errors.size
    assert_equal ["nil object not allowed"], property.errors["base"]
  end

  test "should return true if nil is allowed and a nil object is given" do
    property = DuckHunt::Properties::NestedHash.new :allow_nil => true do |s|
      s.test "name"
    end
    assert_equal true, property.valid?(nil)
    assert_equal 0, property.errors.size
  end
end

class DuckHuntNestedHashNestingInSingleTypeArraySchemasTest < DuckHuntTestCase
  def setup
    @schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.nested_hash do |s|
        s.always_right_type "name", :required => true
      end
    end
  end

  test "should be able to be nested in an array schema" do
    assert_instance_of DuckHunt::Properties::NestedHash, @schema.single_type_property
  end

  test "should return true if the nested hashes are valid" do
    assert_equal true, @schema.validate?([{:name => "Hello"}, {:name => "World"}])
    assert_equal 0, @schema.errors.size
  end

  test "should return false if one of the nested hashes is invalid" do
    assert_equal false, @schema.validate?([{:name => "Hello"}, {:world => "World"}])
    assert_equal 1, @schema.errors.size
    assert_equal ({"base" => ["has properties not defined in schema"]}), @schema.errors["1"]

    assert_equal false, @schema.validate?([{:name => "Hello"}, {}])
    assert_equal 1, @schema.errors.size
    assert_equal ({"name" => ["required"]}), @schema.errors["1"]
  end

  test "should return false if both of the nested hashes are invalid" do
    assert_equal false, @schema.validate?([{}, {}])
    assert_equal 2, @schema.errors.size
    assert_equal ({"name" => ["required"]}), @schema.errors["0"]
    assert_equal ({"name" => ["required"]}), @schema.errors["1"]
  end
end

class DuckHuntNestedHashPropertyNestingInTupleArraySchemasWithNoOptionalPropertiesTest < DuckHuntTestCase
  def setup
    @schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.items do |x|
        x.nested_hash do |z|
          z.always_right_type "name", :required => true
        end

        x.nested_hash do |y|
          y.always_right_type "age", :required => true
        end
      end
    end
  end

  test "should be able to be nested in an array schema" do
    @schema.tuple_properties.each{|x| assert_instance_of DuckHunt::Properties::NestedHash, x}
  end

  test "should return true if the nested hashes are valid" do
    assert_equal true, @schema.validate?([{:name => "Hello"}, {:age => "World"}])
    assert_equal 0, @schema.errors.size
  end

  test "should return false if one of the nested hashes is invalid" do
    assert_equal false, @schema.validate?([{:name => "Hello"}, {:world => "World"}])
    assert_equal 1, @schema.errors.size
    assert_equal ({"base" => ["has properties not defined in schema"]}), @schema.errors["1"]

    assert_equal false, @schema.validate?([{:name => "Hello"}, {}])
    assert_equal 1, @schema.errors.size
    assert_equal ({"age" => ["required"]}), @schema.errors["1"]
  end

  test "should return false if both of the nested hashes are invalid" do
    assert_equal false, @schema.validate?([{}, {}])
    assert_equal 2, @schema.errors.size
    assert_equal ({"name" => ["required"]}), @schema.errors["0"]
    assert_equal ({"age" => ["required"]}), @schema.errors["1"]
  end
end

class DuckHuntNestedHashPropertyNestingInTupleArraySchemasWithOptionalPropertiesTest < DuckHuntTestCase
  def setup
    @schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.items do |x|
        x.nested_hash do |z|
          z.always_right_type "name", :required => true
        end
      end

      s.optional_items do |w|
        w.nested_hash do |y|
          y.always_right_type "age", :required => true
        end
      end
    end
  end

  test "should be able to be nested in an array schema" do
    @schema.tuple_properties.each{|x| assert_instance_of DuckHunt::Properties::NestedHash, x}
    @schema.optional_tuple_properties.each{|x| assert_instance_of DuckHunt::Properties::NestedHash, x}
  end

  test "should return true if the nested hashes are valid" do
    assert_equal true, @schema.validate?([{:name => "Hello"}, {:age => "World"}])
    assert_equal 0, @schema.errors.size
  end

  test "should return true if only the required hashes are provided" do
    assert_equal true, @schema.validate?([{:name => "Hello"}])
    assert_equal 0, @schema.errors.size
  end

  test "should return false if one of the nested hashes is invalid" do
    assert_equal false, @schema.validate?([{:name => "Hello"}, {:world => "World"}])
    assert_equal 1, @schema.errors.size
    assert_equal ({"base" => ["has properties not defined in schema"]}), @schema.errors["1"]

    assert_equal false, @schema.validate?([{:name => "Hello"}, {}])
    assert_equal 1, @schema.errors.size
    assert_equal ({"age" => ["required"]}), @schema.errors["1"]
  end

  test "should return false if both of the nested hashes are invalid" do
    assert_equal false, @schema.validate?([{}, {}])
    assert_equal 2, @schema.errors.size
    assert_equal ({"name" => ["required"]}), @schema.errors["0"]
    assert_equal ({"age" => ["required"]}), @schema.errors["1"]
  end
end

class DuckHuntNestedHashPropertiesNestingInTupleArraySchemasWithAllOptionalPropertiesTest < DuckHuntTestCase
  def setup
    @schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.optional_items do |x|
        x.nested_hash do |z|
          z.always_right_type "name", :required => true
        end

        x.nested_hash do |w|
          w.always_right_type "age", :required => true
        end
      end
    end
  end

  test "should be able to be nested in an array schema" do
    @schema.optional_tuple_properties.each{|x| assert_instance_of DuckHunt::Properties::NestedHash, x}
  end

  test "should return true if the nested hashes are valid" do
    assert_equal true, @schema.validate?([{:name => "Hello"}, {:age => "World"}])
    assert_equal 0, @schema.errors.size
  end

  test "should return true if no hashes are provided" do
    assert_equal true, @schema.validate?([])
    assert_equal 0, @schema.errors.size
  end

  test "should return false if one of the nested hashes is invalid" do
    assert_equal false, @schema.validate?([{:name => "Hello"}, {:world => "World"}])
    assert_equal 1, @schema.errors.size
    assert_equal ({"base" => ["has properties not defined in schema"]}), @schema.errors["1"]

    assert_equal false, @schema.validate?([{}, {:age => "World"}])
    assert_equal 1, @schema.errors.size
    assert_equal ({"name" => ["required"]}), @schema.errors["0"]
  end

  test "should return false if both of the nested hashes are invalid" do
    assert_equal false, @schema.validate?([{}, {}])
    assert_equal 2, @schema.errors.size
    assert_equal ({"name" => ["required"]}), @schema.errors["0"]
    assert_equal ({"age" => ["required"]}), @schema.errors["1"]
  end
end

class DuckHuntNestedHashPropertyInNestedHashesTest < DuckHuntTestCase
  def setup
    @schema = DuckHunt::Schemas::HashSchema.define do |s|
      s.nested_hash "profile" do |x|
        x.always_right_type "name", :required => true
      end

      s.nested_hash "info" do |x|
        x.always_right_type "age", :required => true
      end
    end
  end

  test "should be able to be nested in an array schema" do
    assert_instance_of DuckHunt::Properties::NestedHash, @schema.properties["profile"]
  end

  test "should return true if the nested hashes are valid" do
    assert_equal true, @schema.validate?({:profile => {:name => "John"}, :info => {:age => 35}})
    assert_equal 0, @schema.errors.size
  end

  test "should return false if one of the nested hashes is invalid" do
    assert_equal false, @schema.validate?({:profile => {:name => "John"}, :info => {:birthdate => 35}})
    assert_equal 1, @schema.errors.size
    assert_equal ({"base" => ["has properties not defined in schema"]}), @schema.errors["info"]

    assert_equal false, @schema.validate?({:profile => {:name => "John"}, :info => {}})
    assert_equal 1, @schema.errors.size
    assert_equal ({"age" => ["required"]}), @schema.errors["info"]
  end

  test "should return false if both of the nested hashes are invalid" do
    assert_equal false, @schema.validate?({:profile => {}, :info => {}})
    assert_equal 2, @schema.errors.size
    assert_equal ({"name" => ["required"]}), @schema.errors["profile"]
    assert_equal ({"age" => ["required"]}), @schema.errors["info"]
  end
end