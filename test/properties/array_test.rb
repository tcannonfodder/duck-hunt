require File.expand_path('../../test_helper', __FILE__)

class DuckHuntArrayPropertyInitializedWithBlockTest < DuckHuntTestCase
  test "should be able to set the property to required" do
    property = DuckHunt::Properties::Array.new :required => true do |s|
      s.test
    end
    assert_equal true, property.required
    assert_equal true, property.required?
  end

  test "should be able to define a single-type array" do
    property = DuckHunt::Properties::Array.new do |s|
      s.integer
    end

    assert_instance_of DuckHunt::Properties::Integer, property.single_type_property
    assert_nil property.tuple_properties
    assert_nil property.optional_tuple_properties
  end

  test "should be able to define a tuple array with no optional items" do
    property = DuckHunt::Properties::Array.new do |s|
      s.items do |x|
        x.integer
      end
    end

    assert_equal 1, property.tuple_properties.size
    assert_instance_of DuckHunt::Properties::Integer, property.tuple_properties.first

    property = DuckHunt::Properties::Array.new do |s|
      s.items do |x|
        x.integer
        x.test
      end
    end

    assert_equal 2, property.tuple_properties.size
    assert_instance_of DuckHunt::Properties::Integer, property.tuple_properties.first
    assert_instance_of DuckHunt::Properties::Test, property.tuple_properties.last
  end

  test "should be able to define a tuple array with optional items" do
    property = DuckHunt::Properties::Array.new do |s|
      s.items do |x|
        x.integer
      end

      s.optional_items do |y|
        y.integer
        y.test
      end
    end

    assert_equal 1, property.tuple_properties.size
    assert_instance_of DuckHunt::Properties::Integer, property.tuple_properties.first

    assert_equal 2, property.optional_tuple_properties.size
    assert_instance_of DuckHunt::Properties::Integer, property.optional_tuple_properties.first
    assert_instance_of DuckHunt::Properties::Test, property.optional_tuple_properties.last

    property = DuckHunt::Properties::Array.new do |s|
      s.items do |x|
        x.integer
        x.test
      end

      s.optional_items do |x|
        x.integer
      end
    end

    assert_equal 2, property.tuple_properties.size
    assert_instance_of DuckHunt::Properties::Integer, property.tuple_properties.first
    assert_instance_of DuckHunt::Properties::Test, property.tuple_properties.last

    assert_equal 1, property.optional_tuple_properties.size
    assert_instance_of DuckHunt::Properties::Integer, property.optional_tuple_properties.first
  end

  test "should not allow single-type and tuple definitions in the same property" do
    assert_raises DuckHunt::InvalidSchema do
      property = DuckHunt::Properties::Array.new do |s|
        s.integer
        s.items do |x|
          x.integer
        end
      end
    end

    assert_raises DuckHunt::InvalidSchema do
      property = DuckHunt::Properties::Array.new do |s|
        s.items do |x|
          x.integer
        end
        s.integer
      end
    end

    assert_raises DuckHunt::InvalidSchema do
      property = DuckHunt::Properties::Array.new do |s|
        s.integer
        s.optional_items do |x|
          x.integer
        end
      end
    end

    assert_raises DuckHunt::InvalidSchema do
      property = DuckHunt::Properties::Array.new do |s|
        s.optional_items do |x|
          x.integer
        end
        s.integer
      end
    end
  end

  test "should be able to set options for the property" do
    property = DuckHunt::Properties::Array.new :min_size => 3 do |s|
      s.test
    end

    assert_equal 3, property.min_size
  end

  test "should be able to set property-level and property-level options at the same time" do
    property = DuckHunt::Properties::Array.new :required => true, :min_size => 3 do |s|
      s.test
    end
    assert_equal true, property.required
    assert_equal true, property.required?
    assert_equal 3, property.min_size
  end

  test "should require that a block be passed when setting tuple properties" do
    assert_raises ArgumentError do
      property = DuckHunt::Properties::Array.new do |s|
        s.items
      end
    end

    assert_raises ArgumentError do
      property = DuckHunt::Properties::Array.new do |s|
        s.optional_items
      end
    end
  end

  test "should allow the uniqueness flag to be set during initialization" do
    property = DuckHunt::Properties::Array.new :validates_uniqueness => true do |s|
      s.integer
    end

    assert_equal true, property.validates_uniqueness?
    assert_equal true, property.validates_uniqueness
  end

  test "should allow the min and max size to be set during initialization" do
    property = DuckHunt::Properties::Array.new :min_size => 10 do |s|
      s.integer
    end

    assert_equal 10, property.min_size
    assert_nil property.max_size

    property = DuckHunt::Properties::Array.new :max_size => 10 do |s|
      s.integer
    end

    assert_nil property.min_size
    assert_equal 10, property.max_size

    property = DuckHunt::Properties::Array.new :min_size => 5, :max_size => 10 do |s|
      s.integer
    end

    assert_equal 5, property.min_size
    assert_equal 10, property.max_size
  end

  test "should allow the 'allow nil' flag to be set during initialization" do
    property = DuckHunt::Properties::Array.new :allow_nil => true do |s|
      s.integer
    end

    assert_equal true, property.allow_nil
    assert_equal true, property.allow_nil?
  end

  test "should default the uniqueness flag to false" do
    property = DuckHunt::Properties::Array.new do |s|
      s.integer
    end

    assert_equal false, property.validates_uniqueness
    assert_equal false, property.validates_uniqueness?
  end

  test "should default the min and max size to nil" do
    property = DuckHunt::Properties::Array.new do |s|
      s.integer
    end

    assert_nil property.min_size
    assert_nil property.max_size
  end

  test "should default the 'allow nil' flag to false" do
    property = DuckHunt::Properties::Array.new do |s|
      s.integer
    end

    assert_equal false, property.allow_nil
    assert_equal false, property.allow_nil?
  end
end

class DuckHuntArrayPropertyInitializedWithoutBlockTest < DuckHuntTestCase
  test "should raise an exception if a block is not provided" do
    assert_raises ArgumentError do
     DuckHunt::Properties::Array.new :required => false
    end
  end
end

class DuckHuntArrayPropertySingleTypeValidationTest < DuckHuntTestCase
  def setup
    @property = DuckHunt::Properties::Array.new do |s|
      s.integer
    end
  end

  test "should return false if the object provided is not an array" do
    assert_equal false, @property.valid?("hello")
    assert_equal 1, @property.errors.size
    assert_equal ["wrong type"], @property.errors["base"]
  end

  test "should return true if there are no entries in the array" do
    assert_equal true, @property.valid?([])
    assert_equal 0, @property.errors.size
  end

  test "should return true if every entry in the array is of the correct type" do
    assert_equal true, @property.valid?([1,2,3])
    assert_equal 0, @property.errors.size
  end

  test "should return false if any entry in the array is not of the correct type, and have a base error mesage" do
    assert_equal false, @property.valid?([1,"boo",3])
    assert_equal 1, @property.errors.size
    assert_equal ["wrong type"], @property.errors["1"]
  end

  test "should empty the errors array each time we validate" do
    assert_equal false, @property.valid?([1,"boo",3])
    assert_equal 1, @property.errors.size
    assert_equal ["wrong type"], @property.errors["1"]

    assert_equal false, @property.valid?(["boo",2,3])
    assert_equal 1, @property.errors.size
    assert_equal ["wrong type"], @property.errors["0"]
  end
end

class DuckHuntArrayPropertyTupleValidationNoOptionalItemsTest < DuckHuntTestCase
  def setup
    @property = DuckHunt::Properties::Array.new do |s|
      s.items do |x|
        x.always_right_type
        x.integer
      end
    end
  end

  test "should return false if the object provided is not an array" do
    assert_equal false, @property.valid?("hello")
    assert_equal 1, @property.errors.size
    assert_equal ["wrong type"], @property.errors["base"]
  end

  test "should return false if there are no items in the array" do
    assert_equal false, @property.valid?([])
    assert_equal 1, @property.errors.size
    assert_equal ["expected at least 2 item(s) but got 0 item(s)"], @property.errors["base"]
  end

  test "should return false if there are fewer items in the array than what is defined in the tuple" do
    assert_equal false, @property.valid?([1])
    assert_equal 1, @property.errors.size
    assert_equal ["expected at least 2 item(s) but got 1 item(s)"], @property.errors["base"]
  end

  test "should return false if there are more items in the array than what is defined in the tuple" do
    assert_equal false, @property.valid?([1,2,3])
    assert_equal 1, @property.errors.size
    assert_equal ["expected at most 2 item(s) but got 3 item(s)"], @property.errors["base"]
  end

  test "should return false if any of the items are not the correct type specified for that index" do
    assert_equal false, @property.valid?([1, "hello"])
    assert_equal 1, @property.errors.size
    assert_equal ["wrong type"], @property.errors["1"]
  end

  test "should return true if the items in the array match their defined type" do
    assert_equal true, @property.valid?([1, 2])
    assert_equal 0, @property.errors.size
  end

  test "should empty the errors array each time we validate" do
    assert_equal false, @property.valid?([1, "hello"])
    assert_equal 1, @property.errors.size
    assert_equal ["wrong type"], @property.errors["1"]

    assert_equal false, @property.valid?([1])
    assert_equal 1, @property.errors.size
    assert_equal ["expected at least 2 item(s) but got 1 item(s)"], @property.errors["base"]
  end
end

class DuckHuntArrayPropertyTupleValidationWithOptionalItemsTest < DuckHuntTestCase
  def setup
    @property = DuckHunt::Properties::Array.new do |s|
      s.items do |x|
        x.always_right_type
        x.integer
      end

      s.optional_items do |y|
        y.integer
        y.always_right_type
      end
    end
  end

  test "should return false if there are no items in the array" do
    assert_equal false, @property.valid?([])
    assert_equal 1, @property.errors.size
    assert_equal ["expected at least 2 item(s) but got 0 item(s)"], @property.errors["base"]
  end

  test "should return false if there are fewer items in the array than what is defined in the tuple" do
    assert_equal false, @property.valid?([1])
    assert_equal 1, @property.errors.size
    assert_equal ["expected at least 2 item(s) but got 1 item(s)"], @property.errors["base"]
  end

  test "should return true if we have extended beyond the required tuple items and into the optional items" do
    assert_equal true, @property.valid?([1,2,3,4])
    assert_equal 0, @property.errors.size
  end

  test "should return false if there are more items in the array than what is defined in the tuple (including the optional items)" do
    assert_equal false, @property.valid?([1,2,3,4,5])
    assert_equal 1, @property.errors.size
    assert_equal ["expected at most 4 item(s) but got 5 item(s)"], @property.errors["base"]
  end

  test "should return false if any of the required items are not the correct type specified for that index" do
    assert_equal false, @property.valid?([1, "hello"])
    assert_equal 1, @property.errors.size
    assert_equal ["wrong type"], @property.errors["1"]
  end

  test "should return false if any of the optional items are not the correct type specified for that index" do
    assert_equal false, @property.valid?([1,2,"hello"])
    assert_equal 1, @property.errors.size
    assert_equal ["wrong type"], @property.errors["2"]
  end

  test "should return true if the items in the array match their defined type" do
    assert_equal true, @property.valid?([1,2,3,4])
    assert_equal 0, @property.errors.size
  end

  test "should return true if we only have the required items in the array" do
    assert_equal true, @property.valid?([1,2])
    assert_equal 0, @property.errors.size
  end

  test "should return true if we only have some of the optional items in the array" do
    assert_equal true, @property.valid?([1,2,3])
    assert_equal 0, @property.errors.size
  end

  test "should empty the errors array each time we validate" do
    assert_equal false, @property.valid?([1, "hello"])
    assert_equal 1, @property.errors.size
    assert_equal ["wrong type"], @property.errors["1"]

    assert_equal false, @property.valid?([1])
    assert_equal 1, @property.errors.size
    assert_equal ["expected at least 2 item(s) but got 1 item(s)"], @property.errors["base"]

    assert_equal false, @property.valid?([1,2,"hello"])
    assert_equal 1, @property.errors.size
    assert_equal ["wrong type"], @property.errors["2"]
  end
end

class DuckHuntPropertyArrayTupleValidationAllOptionalItemsTest < DuckHuntTestCase
  def setup
    @property = DuckHunt::Properties::Array.new do |s|
      s.optional_items do |y|
        y.integer
        y.always_right_type
      end
    end
  end

  test "should return true if there are no items in the array" do
    assert_equal true, @property.valid?([])
    assert_equal 0, @property.errors.size
  end

  test "should return true if there are fewer items in the array than what is defined in the tuple" do
    assert_equal true, @property.valid?([1])
    assert_equal 0, @property.errors.size
  end

  test "should return false if there are more items in the array than what is defined in the tuple" do
    assert_equal false, @property.valid?([1,2,3])
    assert_equal 1, @property.errors.size
    assert_equal ["expected at most 2 item(s) but got 3 item(s)"], @property.errors["base"]
  end

  test "should return false if any of the items are not the correct type specified for that index" do
    assert_equal false, @property.valid?(["hello",2])
    assert_equal 1, @property.errors.size
    assert_equal ["wrong type"], @property.errors["0"]
  end

  test "should return true if the items in the array match their defined type" do
    assert_equal true, @property.valid?([1,2])
    assert_equal 0, @property.errors.size
  end

  test "should return true if we only have some of the optional items in the array" do
    assert_equal true, @property.valid?([1])
    assert_equal 0, @property.errors.size
  end

  test "should empty the errors array each time we validate" do
    assert_equal false, @property.valid?(["hello",2])
    assert_equal 1, @property.errors.size
    assert_equal ["wrong type"], @property.errors["0"]

    assert_equal false, @property.valid?([1,2,3])
    assert_equal 1, @property.errors.size
    assert_equal ["expected at most 2 item(s) but got 3 item(s)"], @property.errors["base"]
  end
end

class DuckHuntArrayPropertyValidatingUniquenessTest < DuckHuntTestCase
  test "should return false if there were duplicates in a single-type array" do
    property = DuckHunt::Properties::Array.new :validates_uniqueness => true do |s|
      s.integer
    end

    assert_equal false, property.valid?([1,2,1])
    assert_equal 1, property.errors.size
    assert_equal ["duplicate items are not allowed"], property.errors["base"]
  end

  test "should return false if there were duplicates in a tuple array (no optional items)" do
    property = DuckHunt::Properties::Array.new :validates_uniqueness => true do |s|
      s.items do |x|
        x.integer
        x.integer
        x.integer
      end
    end

    assert_equal false, property.valid?([1,2,1])
    assert_equal 1, property.errors.size
    assert_equal ["duplicate items are not allowed"], property.errors["base"]
  end

  test "should return false if there were duplicates in a tuple array (with optional items)" do
    property = DuckHunt::Properties::Array.new :validates_uniqueness => true do |s|
      s.items do |x|
        x.integer
        x.integer
      end

      s.optional_items do |x|
        x.integer
      end
    end

    assert_equal false, property.valid?([1,2,1])
    assert_equal 1, property.errors.size
    assert_equal ["duplicate items are not allowed"], property.errors["base"]
  end

  test "should return false if there were duplicates in a tuple array (all optional items)" do
    property = DuckHunt::Properties::Array.new :validates_uniqueness => true do |s|
      s.optional_items do |x|
        x.integer
        x.integer
        x.integer
      end
    end

    assert_equal false, property.valid?([1,2,1])
    assert_equal 1, property.errors.size
    assert_equal ["duplicate items are not allowed"], property.errors["base"]
  end
end

class DuckHuntArrayPropertyValidatingMinimumSizeTest < DuckHuntTestCase
  test "should return false if there were not enough items in a single-type array" do
    property = DuckHunt::Properties::Array.new :min_size => 3 do |s|
      s.integer
    end

    assert_equal false, property.valid?([1,2])
    assert_equal 1, property.errors.size
    assert_equal ["expected at least 3 item(s) but got 2 item(s)"], property.errors["base"]
  end

  test "should return true if there were just enough items in a single-type array" do
    property = DuckHunt::Properties::Array.new :min_size => 3 do |s|
      s.integer
    end

    assert_equal true, property.valid?([1,2,3])
    assert_equal 0, property.errors.size
  end

  test "should return true if there were more than enough items in a single-type array" do
    property = DuckHunt::Properties::Array.new :min_size => 3 do |s|
      s.integer
    end

    assert_equal true, property.valid?([1,2,3,4])
    assert_equal 0, property.errors.size
  end
end

class DuckHuntArrayPropertyValidatingMaximumSizeTest < DuckHuntTestCase
  test "should return false if there were too many items in a single-type array" do
    property = DuckHunt::Properties::Array.new :max_size => 3 do |s|
      s.integer
    end

    assert_equal false, property.valid?([1,2,3,4])
    assert_equal 1, property.errors.size
    assert_equal ["expected at most 3 item(s) but got 4 item(s)"], property.errors["base"]
  end

  test "should return true if we were at the limit of items in a single-type array" do
    property = DuckHunt::Properties::Array.new :max_size => 3 do |s|
      s.integer
    end

    assert_equal true, property.valid?([1,2,3])
    assert_equal 0, property.errors.size
  end

  test "should return true if we were not close to the limit in a single-type array" do
    property = DuckHunt::Properties::Array.new :max_size => 3 do |s|
      s.integer
    end

    assert_equal true, property.valid?([1])
    assert_equal 0, property.errors.size
  end
end

class DuckHuntArrayPropertyValidatingMinimumAndMaximumSizeTest < DuckHuntTestCase
  def setup
    @property = DuckHunt::Properties::Array.new :min_size => 3, :max_size => 5 do |s|
      s.integer
    end
  end

  test "should return false if it is below the minimum" do
    assert_equal false, @property.valid?([1,2])
    assert_equal 1, @property.errors.size
    assert_equal ["expected at least 3 item(s) but got 2 item(s)"], @property.errors["base"]
  end

  test "should return false if it is above the maximum" do
    assert_equal false, @property.valid?([1,2,3,4,5,6])
    assert_equal 1, @property.errors.size
    assert_equal ["expected at most 5 item(s) but got 6 item(s)"], @property.errors["base"]
  end

  test "should return true if it is at the minimum" do
    assert_equal true, @property.valid?([1,2,3])
    assert_equal 0, @property.errors.size
  end

  test "should return true if it is at the maximum" do
    assert_equal true, @property.valid?([1,2,3,4,5])
    assert_equal 0, @property.errors.size
  end

  test "should return true if it is within the range" do
    assert_equal true, @property.valid?([1,2,3,4])
    assert_equal 0, @property.errors.size
  end

  test "should return true if the min and max are the same value" do
    property = DuckHunt::Properties::Array.new :min_size => 3, :max_size => 3 do |s|
      s.integer
    end
    assert_equal true, property.valid?([1,2,3])
    assert_equal 0, property.errors.size
  end
end

class DuckHuntArrayPropertyAllowNilTest < DuckHuntTestCase
  test "should return false if nil is not allowed and a nil object is given" do
    property = DuckHunt::Properties::Array.new :allow_nil => false do |s|
      s.integer
    end
    assert_equal false, property.valid?(nil)
    assert_equal 1, property.errors.size
    assert_equal ["nil object not allowed"], property.errors["base"]
  end

  test "should return true if nil is allowed and a nil object is given" do
    property = DuckHunt::Properties::Array.new :allow_nil => true do |s|
      s.integer
    end
    assert_equal true, property.valid?(nil)
    assert_equal 0, property.errors.size
  end
end

class DuckHuntArrayPropertySingleTypeArraySchemaTest < DuckHuntTestCase
  def setup
    @schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.array do |s|
        s.integer
      end
    end
  end

  test "should be able to be nested in an array schema" do
    assert_instance_of DuckHunt::Properties::Array, @schema.single_type_property
  end

  test "should return true if the nested arrays are valid" do
    assert_equal true, @schema.validate?([[1,2,3], [4,5,6]])
    assert_equal 0, @schema.errors.size
  end

  test "should return false if one of the nested arrays is invalid" do
    assert_equal false, @schema.validate?([[1,2,3], [4,"herp",6]])
    assert_equal 1, @schema.errors.size
    assert_equal ({"1" => ["wrong type"]}), @schema.errors["1"]
  end

  test "should return false if both of the nested arrays are invalid" do
    assert_equal false, @schema.validate?([{}, {}])
    assert_equal 2, @schema.errors.size
    assert_equal ({"base" => ["wrong type"]}), @schema.errors["0"]
    assert_equal ({"base" => ["wrong type"]}), @schema.errors["1"]
  end
end

class DuckHuntArrayPropertyNestedTupleArraySchemesWithNoOptionalProperties < DuckHuntTestCase
  def setup
    @schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.items do |x|
        x.array do |z|
          z.integer
        end

        x.array do |y|
          y.integer
        end
      end
    end
  end

  test "should be able to be nested in an array schema" do
    @schema.tuple_properties.each{|x| assert_instance_of DuckHunt::Properties::Array, x}
  end

  test "should return true if the nested arrays are valid" do
    assert_equal true, @schema.validate?([[1,2,3], [4,5,6]])
    assert_equal 0, @schema.errors.size
  end

  test "should return false if one of the nested arrays is invalid" do
    assert_equal false, @schema.validate?([[1,2,3], [4,"herp",6]])
    assert_equal 1, @schema.errors.size
    assert_equal ({"1" => ["wrong type"]}), @schema.errors["1"]
  end

  test "should return false if both of the nested arrays are invalid" do
    assert_equal false, @schema.validate?([{}, {}])
    assert_equal 2, @schema.errors.size
    assert_equal ({"base" => ["wrong type"]}), @schema.errors["0"]
    assert_equal ({"base" => ["wrong type"]}), @schema.errors["1"]
  end
end

class DuckHuntArrayPropertyNestingInTupleArraySchemaWithOptionalProperties < DuckHuntTestCase
  def setup
    @schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.items do |x|
        x.array do |z|
          z.integer
        end
      end

      s.optional_items do |w|
        w.array do |y|
          y.integer
        end
      end
    end
  end

  test "should be able to be nested in an array schema" do
    @schema.tuple_properties.each{|x| assert_instance_of DuckHunt::Properties::Array, x}
    @schema.optional_tuple_properties.each{|x| assert_instance_of DuckHunt::Properties::Array, x}
  end

  test "should return true if the nested arrays are valid" do
    assert_equal true, @schema.validate?([[1,2,3], [4,5,6]])
    assert_equal 0, @schema.errors.size
  end

  test "should return true if only the required arrays are provided" do
    assert_equal true, @schema.validate?([[1,2,3]])
    assert_equal 0, @schema.errors.size
  end

  test "should return false if one of the nested arrays is invalid" do
    assert_equal false, @schema.validate?([[1,2,3], [4,"herp",6]])
    assert_equal 1, @schema.errors.size
    assert_equal ({"1" => ["wrong type"]}), @schema.errors["1"]

    assert_equal false, @schema.validate?([[1,"herp",3], [4,5,6]])
    assert_equal 1, @schema.errors.size
    assert_equal ({"1" => ["wrong type"]}), @schema.errors["0"]
  end

  test "should return false if both of the nested arrays are invalid" do
    assert_equal false, @schema.validate?([{}, {}])
    assert_equal 2, @schema.errors.size
    assert_equal ({"base" => ["wrong type"]}), @schema.errors["0"]
    assert_equal ({"base" => ["wrong type"]}), @schema.errors["1"]
  end
end

class DuckHuntArrayPropertyNestedInTupleArraySchemesWithAllOptionalPropertiesTest < DuckHuntTestCase
  def setup
    @schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.optional_items do |x|
        x.array do |z|
          z.integer
        end

        x.array do |w|
          w.integer
        end
      end
    end
  end

  test "should be able to be nested in an array schema" do
    @schema.optional_tuple_properties.each{|x| assert_instance_of DuckHunt::Properties::Array, x}
  end

  test "should return true if the nested arrays are valid" do
    assert_equal true, @schema.validate?([[1,2,3], [4,5,6]])
    assert_equal 0, @schema.errors.size
  end

  test "should return true if no arrays are provided" do
    assert_equal true, @schema.validate?([])
    assert_equal 0, @schema.errors.size
  end

  test "should return false if one of the nested arrays is invalid" do
    assert_equal false, @schema.validate?([[1,2,3], [4,"herp",6]])
    assert_equal 1, @schema.errors.size
    assert_equal ({"1" => ["wrong type"]}), @schema.errors["1"]
  end

  test "should return false if both of the nested arrays are invalid" do
    assert_equal false, @schema.validate?([{}, {}])
    assert_equal 2, @schema.errors.size
    assert_equal ({"base" => ["wrong type"]}), @schema.errors["0"]
    assert_equal ({"base" => ["wrong type"]}), @schema.errors["1"]
  end
end

class DuckHuntArrayPropertyNestingInHashTest < DuckHuntTestCase
  def setup
    @schema = DuckHunt::Schemas::HashSchema.define do |s|
      s.array "profile" do |x|
        x.integer
      end

      s.array "info" do |x|
        x.integer
      end
    end
  end

  test "should be able to be nested in a hash schema" do
    assert_instance_of DuckHunt::Properties::Array, @schema.properties["profile"]
  end

  test "should return true if the nested arrays are valid" do
    assert_equal true, @schema.validate?({:profile => [1,2,3], :info => [4,5,6]})
    assert_equal 0, @schema.errors.size
  end

  test "should return false if one of the nested arrays is invalid" do
    assert_equal false, @schema.validate?({:profile => [1,2,3], :info => {:birthdate => 35}})
    assert_equal 1, @schema.errors.size
    assert_equal ({"base" => ["wrong type"]}), @schema.errors["info"]

    assert_equal false, @schema.validate?({:profile => {:name => "John"}, :info => [4,5,6]})
    assert_equal 1, @schema.errors.size
    assert_equal ({"base" => ["wrong type"]}), @schema.errors["profile"]
  end

  test "should return false if both of the nested arrays are invalid" do
    assert_equal false, @schema.validate?({:profile => {}, :info => {}})
    assert_equal 2, @schema.errors.size
    assert_equal ({"base" => ["wrong type"]}), @schema.errors["profile"]
    assert_equal ({"base" => ["wrong type"]}), @schema.errors["info"]
  end
end