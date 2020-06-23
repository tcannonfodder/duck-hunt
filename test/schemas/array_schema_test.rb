require File.expand_path('../../test_helper', __FILE__)

class DuckHuntArraySchemaDefinedThroughBlockTest < DuckHuntTestCase
  test "should be able to define a single-type array" do
    schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.integer
    end

    assert_instance_of DuckHunt::Properties::Integer, schema.single_type_property
    assert_nil schema.tuple_properties
    assert_nil schema.optional_tuple_properties
  end

  test "should be able to define a tuple array with no optional items" do
    schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.items do |x|
        x.integer
      end
    end

    assert_equal 1, schema.tuple_properties.size
    assert_instance_of DuckHunt::Properties::Integer, schema.tuple_properties.first

    schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.items do |x|
        x.integer
        x.test
      end
    end

    assert_equal 2, schema.tuple_properties.size
    assert_instance_of DuckHunt::Properties::Integer, schema.tuple_properties.first
    assert_instance_of DuckHunt::Properties::Test, schema.tuple_properties.last
  end

  test "should be able to define a tuple array with optional items" do
    schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.items do |x|
        x.integer
      end

      s.optional_items do |y|
        y.integer
        y.test
      end
    end

    assert_equal 1, schema.tuple_properties.size
    assert_instance_of DuckHunt::Properties::Integer, schema.tuple_properties.first

    assert_equal 2, schema.optional_tuple_properties.size
    assert_instance_of DuckHunt::Properties::Integer, schema.optional_tuple_properties.first
    assert_instance_of DuckHunt::Properties::Test, schema.optional_tuple_properties.last

    schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.items do |x|
        x.integer
        x.test
      end

      s.optional_items do |x|
        x.integer
      end
    end

    assert_equal 2, schema.tuple_properties.size
    assert_instance_of DuckHunt::Properties::Integer, schema.tuple_properties.first
    assert_instance_of DuckHunt::Properties::Test, schema.tuple_properties.last

    assert_equal 1, schema.optional_tuple_properties.size
    assert_instance_of DuckHunt::Properties::Integer, schema.optional_tuple_properties.first
  end

  test "should not allow single-type and tuple definitions in the same schema" do
    assert_raises DuckHunt::InvalidSchema do
      schema = DuckHunt::Schemas::ArraySchema.define do |s|
        s.integer
        s.items do |x|
          x.integer
        end
      end
    end

    assert_raises DuckHunt::InvalidSchema do
      schema = DuckHunt::Schemas::ArraySchema.define do |s|
        s.items do |x|
          x.integer
        end
        s.integer
      end
    end

    assert_raises DuckHunt::InvalidSchema do
      schema = DuckHunt::Schemas::ArraySchema.define do |s|
        s.integer
        s.optional_items do |x|
          x.integer
        end
      end
    end

    assert_raises DuckHunt::InvalidSchema do
      schema = DuckHunt::Schemas::ArraySchema.define do |s|
        s.optional_items do |x|
          x.integer
        end
        s.integer
      end
    end
  end

  test "should pass a block down to the property that defines a single-type array" do
    schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.test_block_passed {1+1}
    end

    assert_equal true, schema.single_type_property.block_passed
  end

  test "should pass a block down to the properties in a tuple array" do
    schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.items do |x|
        x.test_block_passed {1+1}
      end

      s.optional_items do |y|
        y.test_block_passed {1+1}
      end
    end

    assert_equal true, schema.tuple_properties.first.block_passed
    assert_equal true, schema.optional_tuple_properties.first.block_passed
  end

  test "should require that a block be passed when setting tuple properties" do
    assert_raises ArgumentError do
      schema = DuckHunt::Schemas::ArraySchema.define do |s|
        s.items
      end
    end

    assert_raises ArgumentError do
      schema = DuckHunt::Schemas::ArraySchema.define do |s|
        s.optional_items
      end
    end
  end

  test "should allow the uniqueness flag to be set during initialization" do
    schema = DuckHunt::Schemas::ArraySchema.define :validates_uniqueness => true do |s|
      s.integer
    end

    assert_equal true, schema.validates_uniqueness?
    assert_equal true, schema.validates_uniqueness
  end

  test "should allow the min and max size to be set during initialization" do
    schema = DuckHunt::Schemas::ArraySchema.define :min_size => 10 do |s|
      s.integer
    end

    assert_equal 10, schema.min_size
    assert_nil schema.max_size

    schema = DuckHunt::Schemas::ArraySchema.define :max_size => 10 do |s|
      s.integer
    end

    assert_nil schema.min_size
    assert_equal 10, schema.max_size

    schema = DuckHunt::Schemas::ArraySchema.define :min_size => 5, :max_size => 10 do |s|
      s.integer
    end

    assert_equal 5, schema.min_size
    assert_equal 10, schema.max_size
  end

  test "should allow the 'allow nil' flag to be set during initialization" do
    schema = DuckHunt::Schemas::ArraySchema.define :allow_nil => true do |s|
      s.integer
    end

    assert_equal true, schema.allow_nil
    assert_equal true, schema.allow_nil?
  end

  test "should default the uniqueness flag to false" do
    schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.integer
    end

    assert_equal false, schema.validates_uniqueness
    assert_equal false, schema.validates_uniqueness?
  end

  test "should default the min and max size to nil" do
    schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.integer
    end

    assert_nil schema.min_size
    assert_nil schema.max_size
  end

  test "should default the 'allow nil' flag to false" do
    schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.integer
    end

    assert_equal false, schema.allow_nil
    assert_equal false, schema.allow_nil?
  end
end

class DuckHuntArraySchemaDefiningWithoutABlockTest < DuckHuntTestCase
  test "should be able to define a single-type array" do
    schema = DuckHunt::Schemas::ArraySchema.new
    schema.integer

    assert_instance_of DuckHunt::Properties::Integer, schema.single_type_property
    assert_nil schema.tuple_properties
    assert_nil schema.optional_tuple_properties
  end

  test "should be able to define a tuple array with no optional items" do
    schema = DuckHunt::Schemas::ArraySchema.new
    schema.items do |x|
      x.integer
    end

    assert_equal 1, schema.tuple_properties.size
    assert_instance_of DuckHunt::Properties::Integer, schema.tuple_properties.first

    schema = DuckHunt::Schemas::ArraySchema.new
    schema.items do |x|
      x.integer
      x.test
    end

    assert_equal 2, schema.tuple_properties.size
    assert_instance_of DuckHunt::Properties::Integer, schema.tuple_properties.first
    assert_instance_of DuckHunt::Properties::Test, schema.tuple_properties.last
  end

  test "should be able to define a tuple array with optional items" do
    schema = DuckHunt::Schemas::ArraySchema.new
    schema.items do |x|
      x.integer
    end

    schema.optional_items do |y|
      y.integer
      y.test
    end

    assert_equal 1, schema.tuple_properties.size
    assert_instance_of DuckHunt::Properties::Integer, schema.tuple_properties.first

    assert_equal 2, schema.optional_tuple_properties.size
    assert_instance_of DuckHunt::Properties::Integer, schema.optional_tuple_properties.first
    assert_instance_of DuckHunt::Properties::Test, schema.optional_tuple_properties.last

    schema = DuckHunt::Schemas::ArraySchema.new
    schema.items do |x|
      x.integer
      x.test
    end

    schema.optional_items do |x|
      x.integer
    end

    assert_equal 2, schema.tuple_properties.size
    assert_instance_of DuckHunt::Properties::Integer, schema.tuple_properties.first
    assert_instance_of DuckHunt::Properties::Test, schema.tuple_properties.last

    assert_equal 1, schema.optional_tuple_properties.size
    assert_instance_of DuckHunt::Properties::Integer, schema.optional_tuple_properties.first
  end

  test "should not allow single-type and tuple definitions in the same schema" do
    assert_raises DuckHunt::InvalidSchema do
      schema = DuckHunt::Schemas::ArraySchema.new
      schema.integer
      schema.items do |x|
        x.integer
      end
    end

    assert_raises DuckHunt::InvalidSchema do
      schema = DuckHunt::Schemas::ArraySchema.new
      schema.items do |x|
        x.integer
      end
      schema.integer
    end

    assert_raises DuckHunt::InvalidSchema do
      schema = DuckHunt::Schemas::ArraySchema.new
      schema.integer
      schema.optional_items do |x|
        x.integer
      end
    end

    assert_raises DuckHunt::InvalidSchema do
      schema = DuckHunt::Schemas::ArraySchema.new
      schema.optional_items do |x|
        x.integer
      end
      schema.integer
    end
  end

  test "should require that a block be passed when setting tuple properties" do
    assert_raises ArgumentError do
      schema = DuckHunt::Schemas::ArraySchema.new
      schema.items
    end

    assert_raises ArgumentError do
      schema = DuckHunt::Schemas::ArraySchema.new
      schema.optional_items
    end
  end

  test "should allow the uniqueness flag to be set during initialization" do
    schema = DuckHunt::Schemas::ArraySchema.new(:validates_uniqueness => true)
    schema.integer

    assert_equal true, schema.validates_uniqueness?
    assert_equal true, schema.validates_uniqueness
  end

  test "should allow the min and max size to be set during initialization" do
    schema = DuckHunt::Schemas::ArraySchema.new(:min_size => 10)
    schema.integer

    assert_equal 10, schema.min_size
    assert_nil schema.max_size

    schema = DuckHunt::Schemas::ArraySchema.new :max_size => 10
    schema.integer

    assert_nil schema.min_size
    assert_equal 10, schema.max_size

    schema = DuckHunt::Schemas::ArraySchema.new :min_size => 5, :max_size => 10
    schema.integer

    assert_equal 5, schema.min_size
    assert_equal 10, schema.max_size
  end

  test "should allow the 'allow nil' flag to be set during initialization" do
    schema = DuckHunt::Schemas::ArraySchema.new(:allow_nil => true)
    schema.integer

    assert_equal true, schema.allow_nil
    assert_equal true, schema.allow_nil?
  end

  test "should default the uniqueness flag to false" do
    schema = DuckHunt::Schemas::ArraySchema.new
    schema.integer

    assert_equal false, schema.validates_uniqueness
    assert_equal false, schema.validates_uniqueness?
  end

  test "should default the min and max size to nil" do
    schema = DuckHunt::Schemas::ArraySchema.new
    schema.integer

    assert_nil schema.min_size
    assert_nil schema.max_size
  end

  test "should default the 'allow nil' flag to false" do
    schema = DuckHunt::Schemas::ArraySchema.new
    schema.integer

    assert_equal false, schema.allow_nil
    assert_equal false, schema.allow_nil?
  end
end

class DuckHuntArraySchemaSingleTypeValidationTest < DuckHuntTestCase
  def setup
    @schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.integer
    end
  end

  test "should return false if the object provided is not an array" do
    assert_equal false, @schema.validate?("hello")
    assert_equal 1, @schema.errors.size
    assert_equal ["wrong type"], @schema.errors["base"]
  end

  test "should return true if there are no entries in the array" do
    assert_equal true, @schema.validate?([])
    assert_equal 0, @schema.errors.size
  end

  test "should return true if every entry in the array is of the correct type" do
    assert_equal true, @schema.validate?([1,2,3])
    assert_equal 0, @schema.errors.size
  end

  test "should return false if any entry in the array is not of the correct type, and have a base error mesage" do
    assert_equal false, @schema.validate?([1,"boo",3])
    assert_equal 1, @schema.errors.size
    assert_equal ["wrong type"], @schema.errors["1"]
  end

  test "should empty the errors array each time we validate" do
    assert_equal false, @schema.validate?([1,"boo",3])
    assert_equal 1, @schema.errors.size
    assert_equal ["wrong type"], @schema.errors["1"]

    assert_equal false, @schema.validate?(["boo",2,3])
    assert_equal 1, @schema.errors.size
    assert_equal ["wrong type"], @schema.errors["0"]
  end
end

class DuckHuntArraySchemaTupleWithNoOptionalItemsTest < DuckHuntTestCase
  def setup
    @schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.items do |x|
        x.always_right_type
        x.integer
      end
    end
  end

  test "should return false if the object provided is not an array" do
    assert_equal false, @schema.validate?("hello")
    assert_equal 1, @schema.errors.size
    assert_equal ["wrong type"], @schema.errors["base"]
  end

  test "should return false if there are no items in the array" do
    assert_equal false, @schema.validate?([])
    assert_equal 1, @schema.errors.size
    assert_equal ["expected at least 2 item(s) but got 0 item(s)"], @schema.errors["base"]
  end

  test "should return false if there are fewer items in the array than what is defined in the tuple" do
    assert_equal false, @schema.validate?([1])
    assert_equal 1, @schema.errors.size
    assert_equal ["expected at least 2 item(s) but got 1 item(s)"], @schema.errors["base"]
  end

  test "should return false if there are more items in the array than what is defined in the tuple" do
    assert_equal false, @schema.validate?([1,2,3])
    assert_equal 1, @schema.errors.size
    assert_equal ["expected at most 2 item(s) but got 3 item(s)"], @schema.errors["base"]
  end

  test "should return false if any of the items are not the correct type specified for that index" do
    assert_equal false, @schema.validate?([1, "hello"])
    assert_equal 1, @schema.errors.size
    assert_equal ["wrong type"], @schema.errors["1"]
  end

  test "should return true if the items in the array match their defined type" do
    assert_equal true, @schema.validate?([1, 2])
    assert_equal 0, @schema.errors.size
  end

  test "should empty the errors array each time we validate" do
    assert_equal false, @schema.validate?([1, "hello"])
    assert_equal 1, @schema.errors.size
    assert_equal ["wrong type"], @schema.errors["1"]

    assert_equal false, @schema.validate?([1])
    assert_equal 1, @schema.errors.size
    assert_equal ["expected at least 2 item(s) but got 1 item(s)"], @schema.errors["base"]
  end
end

class DuckHuntArraySchemaTupleWithOptionalItemsTest < DuckHuntTestCase
  def setup
    @schema = DuckHunt::Schemas::ArraySchema.define do |s|
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
    assert_equal false, @schema.validate?([])
    assert_equal 1, @schema.errors.size
    assert_equal ["expected at least 2 item(s) but got 0 item(s)"], @schema.errors["base"]
  end

  test "should return false if there are fewer items in the array than what is defined in the tuple" do
    assert_equal false, @schema.validate?([1])
    assert_equal 1, @schema.errors.size
    assert_equal ["expected at least 2 item(s) but got 1 item(s)"], @schema.errors["base"]
  end

  test "should return true if we have extended beyond the required tuple items and into the optional items" do
    assert_equal true, @schema.validate?([1,2,3,4])
    assert_equal 0, @schema.errors.size
  end

  test "should return false if there are more items in the array than what is defined in the tuple (including the optional items)" do
    assert_equal false, @schema.validate?([1,2,3,4,5])
    assert_equal 1, @schema.errors.size
    assert_equal ["expected at most 4 item(s) but got 5 item(s)"], @schema.errors["base"]
  end

  test "should return false if any of the required items are not the correct type specified for that index" do
    assert_equal false, @schema.validate?([1, "hello"])
    assert_equal 1, @schema.errors.size
    assert_equal ["wrong type"], @schema.errors["1"]
  end

  test "should return false if any of the optional items are not the correct type specified for that index" do
    assert_equal false, @schema.validate?([1,2,"hello"])
    assert_equal 1, @schema.errors.size
    assert_equal ["wrong type"], @schema.errors["2"]
  end

  test "should return true if the items in the array match their defined type" do
    assert_equal true, @schema.validate?([1,2,3,4])
    assert_equal 0, @schema.errors.size
  end

  test "should return true if we only have the required items in the array" do
    assert_equal true, @schema.validate?([1,2])
    assert_equal 0, @schema.errors.size
  end

  test "should return true if we only have some of the optional items in the array" do
    assert_equal true, @schema.validate?([1,2,3])
    assert_equal 0, @schema.errors.size
  end

  test "should empty the errors array each time we validate" do
    assert_equal false, @schema.validate?([1, "hello"])
    assert_equal 1, @schema.errors.size
    assert_equal ["wrong type"], @schema.errors["1"]

    assert_equal false, @schema.validate?([1])
    assert_equal 1, @schema.errors.size
    assert_equal ["expected at least 2 item(s) but got 1 item(s)"], @schema.errors["base"]

    assert_equal false, @schema.validate?([1,2,"hello"])
    assert_equal 1, @schema.errors.size
    assert_equal ["wrong type"], @schema.errors["2"]
  end
end

class DuckHuntArraySchemaTupleOfAllOptionalItemsTest < DuckHuntTestCase
  def setup
    @schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.optional_items do |y|
        y.integer
        y.always_right_type
      end
    end
  end

  test "should return true if there are no items in the array" do
    assert_equal true, @schema.validate?([])
    assert_equal 0, @schema.errors.size
  end

  test "should return true if there are fewer items in the array than what is defined in the tuple" do
    assert_equal true, @schema.validate?([1])
    assert_equal 0, @schema.errors.size
  end

  test "should return false if there are more items in the array than what is defined in the tuple" do
    assert_equal false, @schema.validate?([1,2,3])
    assert_equal 1, @schema.errors.size
    assert_equal ["expected at most 2 item(s) but got 3 item(s)"], @schema.errors["base"]
  end

  test "should return false if any of the items are not the correct type specified for that index" do
    assert_equal false, @schema.validate?(["hello",2])
    assert_equal 1, @schema.errors.size
    assert_equal ["wrong type"], @schema.errors["0"]
  end

  test "should return true if the items in the array match their defined type" do
    assert_equal true, @schema.validate?([1,2])
    assert_equal 0, @schema.errors.size
  end

  test "should return true if we only have some of the optional items in the array" do
    assert_equal true, @schema.validate?([1])
    assert_equal 0, @schema.errors.size
  end

  test "should empty the errors array each time we validate" do
    assert_equal false, @schema.validate?(["hello",2])
    assert_equal 1, @schema.errors.size
    assert_equal ["wrong type"], @schema.errors["0"]

    assert_equal false, @schema.validate?([1,2,3])
    assert_equal 1, @schema.errors.size
    assert_equal ["expected at most 2 item(s) but got 3 item(s)"], @schema.errors["base"]
  end
end

class DuckHuntArraySchemaUniquenessValidationTest < DuckHuntTestCase
  test "should return false if there were duplicates in a single-type array" do
    schema = DuckHunt::Schemas::ArraySchema.define :validates_uniqueness => true do |s|
      s.integer
    end

    assert_equal false, schema.validate?([1,2,1])
    assert_equal 1, schema.errors.size
    assert_equal ["duplicate items are not allowed"], schema.errors["base"]
  end

  test "should return false if there were duplicates in a tuple array (no optional items)" do
    schema = DuckHunt::Schemas::ArraySchema.define :validates_uniqueness => true do |s|
      s.items do |x|
        x.integer
        x.integer
        x.integer
      end
    end

    assert_equal false, schema.validate?([1,2,1])
    assert_equal 1, schema.errors.size
    assert_equal ["duplicate items are not allowed"], schema.errors["base"]
  end

  test "should return false if there were duplicates in a tuple array (with optional items)" do
    schema = DuckHunt::Schemas::ArraySchema.define :validates_uniqueness => true do |s|
      s.items do |x|
        x.integer
        x.integer
      end

      s.optional_items do |x|
        x.integer
      end
    end

    assert_equal false, schema.validate?([1,2,1])
    assert_equal 1, schema.errors.size
    assert_equal ["duplicate items are not allowed"], schema.errors["base"]
  end

  test "should return false if there were duplicates in a tuple array (all optional items)" do
    schema = DuckHunt::Schemas::ArraySchema.define :validates_uniqueness => true do |s|
      s.optional_items do |x|
        x.integer
        x.integer
        x.integer
      end
    end

    assert_equal false, schema.validate?([1,2,1])
    assert_equal 1, schema.errors.size
    assert_equal ["duplicate items are not allowed"], schema.errors["base"]
  end
end

class DuckHuntArraySchemaMinimumSizeValidationTest < DuckHuntTestCase
  test "should return false if there were not enough items in a single-type array" do
    schema = DuckHunt::Schemas::ArraySchema.define :min_size => 3 do |s|
      s.integer
    end

    assert_equal false, schema.validate?([1,2])
    assert_equal 1, schema.errors.size
    assert_equal ["expected at least 3 item(s) but got 2 item(s)"], schema.errors["base"]
  end

  test "should return true if there were just enough items in a single-type array" do
    schema = DuckHunt::Schemas::ArraySchema.define :min_size => 3 do |s|
      s.integer
    end

    assert_equal true, schema.validate?([1,2,3])
    assert_equal 0, schema.errors.size
  end

  test "should return true if there were more than enough items in a single-type array" do
    schema = DuckHunt::Schemas::ArraySchema.define :min_size => 3 do |s|
      s.integer
    end

    assert_equal true, schema.validate?([1,2,3,4])
    assert_equal 0, schema.errors.size
  end
end

class DuckHuntArraySchemaMaximumSizeValidationTest < DuckHuntTestCase
  test "should return false if there were too many items in a single-type array" do
    schema = DuckHunt::Schemas::ArraySchema.define :max_size => 3 do |s|
      s.integer
    end

    assert_equal false, schema.validate?([1,2,3,4])
    assert_equal 1, schema.errors.size
    assert_equal ["expected at most 3 item(s) but got 4 item(s)"], schema.errors["base"]
  end

  test "should return true if we were at the limit of items in a single-type array" do
    schema = DuckHunt::Schemas::ArraySchema.define :max_size => 3 do |s|
      s.integer
    end

    assert_equal true, schema.validate?([1,2,3])
    assert_equal 0, schema.errors.size
  end

  test "should return true if we were not close to the limit in a single-type array" do
    schema = DuckHunt::Schemas::ArraySchema.define :max_size => 3 do |s|
      s.integer
    end

    assert_equal true, schema.validate?([1])
    assert_equal 0, schema.errors.size
  end
end

class DuckHuntArraySchemaMinimumAndMaximumSizeValidationTest < DuckHuntTestCase
  def setup
    @schema = DuckHunt::Schemas::ArraySchema.define :min_size => 3, :max_size => 5 do |s|
      s.integer
    end
  end

  test "should return false if it is below the minimum" do
    assert_equal false, @schema.validate?([1,2])
    assert_equal 1, @schema.errors.size
    assert_equal ["expected at least 3 item(s) but got 2 item(s)"], @schema.errors["base"]
  end

  test "should return false if it is above the maximum" do
    assert_equal false, @schema.validate?([1,2,3,4,5,6])
    assert_equal 1, @schema.errors.size
    assert_equal ["expected at most 5 item(s) but got 6 item(s)"], @schema.errors["base"]
  end

  test "should return true if it is at the minimum" do
    assert_equal true, @schema.validate?([1,2,3])
    assert_equal 0, @schema.errors.size
  end

  test "should return true if it is at the maximum" do
    assert_equal true, @schema.validate?([1,2,3,4,5])
    assert_equal 0, @schema.errors.size
  end

  test "should return true if it is within the range" do
    assert_equal true, @schema.validate?([1,2,3,4])
    assert_equal 0, @schema.errors.size
  end

  test "should return true if the min and max are the same value" do
    schema = DuckHunt::Schemas::ArraySchema.define :min_size => 3, :max_size => 3 do |s|
      s.integer
    end
    assert_equal true, schema.validate?([1,2,3])
    assert_equal 0, schema.errors.size
  end
end

class DuckHuntArraySchemaAllowNilValidationTest < DuckHuntTestCase
  test "should return false if nil is not allowed and a nil object is given" do
    schema = DuckHunt::Schemas::ArraySchema.define :allow_nil => false do |s|
      s.integer
    end
    assert_equal false, schema.validate?(nil)
    assert_equal 1, schema.errors.size
    assert_equal ["nil object not allowed"], schema.errors["base"]
  end

  test "should return true if nil is allowed and a nil object is given" do
    schema = DuckHunt::Schemas::ArraySchema.define :allow_nil => true do |s|
      s.integer
    end
    assert_equal true, schema.validate?(nil)
    assert_equal 0, schema.errors.size
  end
end