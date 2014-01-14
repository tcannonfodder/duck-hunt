require File.expand_path('../../test_helper', __FILE__)

describe ObjectSchemas::Schemas::ArraySchema, "defining an object through a block" do
  it "should be able to define a single-type array" do
    schema = ObjectSchemas::Schemas::ArraySchema.define do |s|
      s.integer
    end

    schema.single_type_property.must_be_instance_of ObjectSchemas::Properties::Integer
    schema.tuple_properties.must_be_nil
    schema.optional_tuple_properties.must_be_nil
  end

  it "should be able to define a tuple array with no optional items" do
    schema = ObjectSchemas::Schemas::ArraySchema.define do |s|
      s.items do |x|
        x.integer
      end
    end

    schema.tuple_properties.size.must_equal 1
    schema.tuple_properties.first.must_be_instance_of ObjectSchemas::Properties::Integer

    schema = ObjectSchemas::Schemas::ArraySchema.define do |s|
      s.items do |x|
        x.integer
        x.test
      end
    end

    schema.tuple_properties.size.must_equal 2
    schema.tuple_properties.first.must_be_instance_of ObjectSchemas::Properties::Integer
    schema.tuple_properties.last.must_be_instance_of ObjectSchemas::Properties::Test
  end

  it "should be able to define a tuple array with optional items" do
    schema = ObjectSchemas::Schemas::ArraySchema.define do |s|
      s.items do |x|
        x.integer
      end

      s.optional_items do |y|
        y.integer
        y.test
      end
    end

    schema.tuple_properties.size.must_equal 1
    schema.tuple_properties.first.must_be_instance_of ObjectSchemas::Properties::Integer

    schema.optional_tuple_properties.size.must_equal 2
    schema.optional_tuple_properties.first.must_be_instance_of ObjectSchemas::Properties::Integer
    schema.optional_tuple_properties.last.must_be_instance_of ObjectSchemas::Properties::Test

    schema = ObjectSchemas::Schemas::ArraySchema.define do |s|
      s.items do |x|
        x.integer
        x.test
      end

      s.optional_items do |x|
        x.integer
      end
    end

    schema.tuple_properties.size.must_equal 2
    schema.tuple_properties.first.must_be_instance_of ObjectSchemas::Properties::Integer
    schema.tuple_properties.last.must_be_instance_of ObjectSchemas::Properties::Test

    schema.optional_tuple_properties.size.must_equal 1
    schema.optional_tuple_properties.first.must_be_instance_of ObjectSchemas::Properties::Integer
  end

  it "should not allow single-type and tuple definitions in the same schema" do
    lambda{
      schema = ObjectSchemas::Schemas::ArraySchema.define do |s|
        s.integer
        s.items do |x|
          x.integer
        end
      end
    }.must_raise ObjectSchemas::InvalidSchema

    lambda{
      schema = ObjectSchemas::Schemas::ArraySchema.define do |s|
        s.items do |x|
          x.integer
        end
        s.integer
      end
    }.must_raise ObjectSchemas::InvalidSchema

    lambda{
      schema = ObjectSchemas::Schemas::ArraySchema.define do |s|
        s.integer
        s.optional_items do |x|
          x.integer
        end
      end
    }.must_raise ObjectSchemas::InvalidSchema

    lambda{
      schema = ObjectSchemas::Schemas::ArraySchema.define do |s|
        s.optional_items do |x|
          x.integer
        end
        s.integer
      end
    }.must_raise ObjectSchemas::InvalidSchema
  end

  it "should require that a block be passed when setting tuple properties" do
    lambda{
      schema = ObjectSchemas::Schemas::ArraySchema.define do |s|
        s.items
      end
    }.must_raise ArgumentError

    lambda{
      schema = ObjectSchemas::Schemas::ArraySchema.define do |s|
        s.optional_items
      end
    }.must_raise ArgumentError
  end

  it "should allow the uniqueness flag to be set during initialization" do
    schema = ObjectSchemas::Schemas::ArraySchema.define :validates_uniqueness => true do |s|
      s.integer
    end

    schema.validates_uniqueness?.must_equal true
    schema.validates_uniqueness.must_equal true
  end

  it "should allow the min and max size to be set during initialization" do
    schema = ObjectSchemas::Schemas::ArraySchema.define :min_size => 10 do |s|
      s.integer
    end

    schema.min_size.must_equal 10
    schema.max_size.must_be_nil

    schema = ObjectSchemas::Schemas::ArraySchema.define :max_size => 10 do |s|
      s.integer
    end

    schema.min_size.must_be_nil
    schema.max_size.must_equal 10

    schema = ObjectSchemas::Schemas::ArraySchema.define :min_size => 5, :max_size => 10 do |s|
      s.integer
    end

    schema.min_size.must_equal 5
    schema.max_size.must_equal 10
  end

  it "should allow the 'allow nil' flag to be set during initialization" do
    schema = ObjectSchemas::Schemas::ArraySchema.define :allow_nil => true do |s|
      s.integer
    end

    schema.allow_nil.must_equal true
    schema.allow_nil?.must_equal true
  end

  it "should default the uniqueness flag to false" do
    schema = ObjectSchemas::Schemas::ArraySchema.define do |s|
      s.integer
    end

    schema.validates_uniqueness.must_equal false
    schema.validates_uniqueness?.must_equal false
  end

  it "should default the min and max size to nil" do
    schema = ObjectSchemas::Schemas::ArraySchema.define do |s|
      s.integer
    end

    schema.min_size.must_be_nil
    schema.max_size.must_be_nil
  end

  it "should default the 'allow nil' flag to false" do
    schema = ObjectSchemas::Schemas::ArraySchema.define do |s|
      s.integer
    end

    schema.allow_nil.must_equal false
    schema.allow_nil?.must_equal false
  end
end

describe ObjectSchemas::Schemas::ArraySchema, "defining an object without a block" do
  it "should be able to define a single-type array" do
    schema = ObjectSchemas::Schemas::ArraySchema.new
    schema.integer

    schema.single_type_property.must_be_instance_of ObjectSchemas::Properties::Integer
    schema.tuple_properties.must_be_nil
    schema.optional_tuple_properties.must_be_nil
  end

  it "should be able to define a tuple array with no optional items" do
    schema = ObjectSchemas::Schemas::ArraySchema.new
    schema.items do |x|
      x.integer
    end

    schema.tuple_properties.size.must_equal 1
    schema.tuple_properties.first.must_be_instance_of ObjectSchemas::Properties::Integer

    schema = ObjectSchemas::Schemas::ArraySchema.new
    schema.items do |x|
      x.integer
      x.test
    end

    schema.tuple_properties.size.must_equal 2
    schema.tuple_properties.first.must_be_instance_of ObjectSchemas::Properties::Integer
    schema.tuple_properties.last.must_be_instance_of ObjectSchemas::Properties::Test
  end

  it "should be able to define a tuple array with optional items" do
    schema = ObjectSchemas::Schemas::ArraySchema.new
    schema.items do |x|
      x.integer
    end

    schema.optional_items do |y|
      y.integer
      y.test
    end

    schema.tuple_properties.size.must_equal 1
    schema.tuple_properties.first.must_be_instance_of ObjectSchemas::Properties::Integer

    schema.optional_tuple_properties.size.must_equal 2
    schema.optional_tuple_properties.first.must_be_instance_of ObjectSchemas::Properties::Integer
    schema.optional_tuple_properties.last.must_be_instance_of ObjectSchemas::Properties::Test

    schema = ObjectSchemas::Schemas::ArraySchema.new
    schema.items do |x|
      x.integer
      x.test
    end

    schema.optional_items do |x|
      x.integer
    end

    schema.tuple_properties.size.must_equal 2
    schema.tuple_properties.first.must_be_instance_of ObjectSchemas::Properties::Integer
    schema.tuple_properties.last.must_be_instance_of ObjectSchemas::Properties::Test

    schema.optional_tuple_properties.size.must_equal 1
    schema.optional_tuple_properties.first.must_be_instance_of ObjectSchemas::Properties::Integer
  end

  it "should not allow single-type and tuple definitions in the same schema" do
    lambda{
      schema = ObjectSchemas::Schemas::ArraySchema.new
      schema.integer
      schema.items do |x|
        x.integer
      end
    }.must_raise ObjectSchemas::InvalidSchema

    lambda{
      schema = ObjectSchemas::Schemas::ArraySchema.new
      schema.items do |x|
        x.integer
      end
      schema.integer
    }.must_raise ObjectSchemas::InvalidSchema

    lambda{
      schema = ObjectSchemas::Schemas::ArraySchema.new
      schema.integer
      schema.optional_items do |x|
        x.integer
      end
    }.must_raise ObjectSchemas::InvalidSchema

    lambda{
      schema = ObjectSchemas::Schemas::ArraySchema.new
      schema.optional_items do |x|
        x.integer
      end
      schema.integer
    }.must_raise ObjectSchemas::InvalidSchema
  end

  it "should require that a block be passed when setting tuple properties" do
    lambda{
      schema = ObjectSchemas::Schemas::ArraySchema.new
      schema.items
    }.must_raise ArgumentError

    lambda{
      schema = ObjectSchemas::Schemas::ArraySchema.new
      schema.optional_items
    }.must_raise ArgumentError
  end

  it "should allow the uniqueness flag to be set during initialization" do
    schema = ObjectSchemas::Schemas::ArraySchema.new(:validates_uniqueness => true)
    schema.integer

    schema.validates_uniqueness?.must_equal true
    schema.validates_uniqueness.must_equal true
  end

  it "should allow the min and max size to be set during initialization" do
    schema = ObjectSchemas::Schemas::ArraySchema.new(:min_size => 10)
    schema.integer

    schema.min_size.must_equal 10
    schema.max_size.must_be_nil

    schema = ObjectSchemas::Schemas::ArraySchema.new :max_size => 10
    schema.integer

    schema.min_size.must_be_nil
    schema.max_size.must_equal 10

    schema = ObjectSchemas::Schemas::ArraySchema.new :min_size => 5, :max_size => 10
    schema.integer

    schema.min_size.must_equal 5
    schema.max_size.must_equal 10
  end

  it "should allow the 'allow nil' flag to be set during initialization" do
    schema = ObjectSchemas::Schemas::ArraySchema.new(:allow_nil => true)
    schema.integer

    schema.allow_nil.must_equal true
    schema.allow_nil?.must_equal true
  end

  it "should default the uniqueness flag to false" do
    schema = ObjectSchemas::Schemas::ArraySchema.new
    schema.integer

    schema.validates_uniqueness.must_equal false
    schema.validates_uniqueness?.must_equal false
  end

  it "should default the min and max size to nil" do
    schema = ObjectSchemas::Schemas::ArraySchema.new
    schema.integer

    schema.min_size.must_be_nil
    schema.max_size.must_be_nil
  end

  it "should default the 'allow nil' flag to false" do
    schema = ObjectSchemas::Schemas::ArraySchema.new
    schema.integer

    schema.allow_nil.must_equal false
    schema.allow_nil?.must_equal false
  end
end

describe ObjectSchemas::Schemas::ArraySchema, "single-type validation" do
  before do
    @schema = ObjectSchemas::Schemas::ArraySchema.define do |s|
      s.integer
    end
  end

  it "should return false if the object provided is not an array" do
    @schema.validate?("hello").must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["base"].must_equal ["wrong type"]
  end

  it "should return true if there are no entries in the array" do
    @schema.validate?([]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return true if every entry in the array is of the correct type" do
    @schema.validate?([1,2,3]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return false if any entry in the array is not of the correct type, and have a base error mesage" do
    @schema.validate?([1,"boo",3]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["base"].must_equal ["wrong type at index 1"]
  end
end

describe ObjectSchemas::Schemas::ArraySchema, "tuple validation (no optional items)" do
  before do
    @schema = ObjectSchemas::Schemas::ArraySchema.define do |s|
      s.items do |x|
        x.always_right_type
        x.integer
      end
    end
  end

  it "should return false if the object provided is not an array" do
    @schema.validate?("hello").must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["base"].must_equal ["wrong type"]
  end

  it "should return false if there are no items in the array" do
    @schema.validate?([]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["base"].must_equal ["expected at least 2 item(s) but got 0 item(s)"]
  end

  it "should return false if there are fewer items in the array than what is defined in the tuple" do
    @schema.validate?([1]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["base"].must_equal ["expected at least 2 item(s) but got 1 item(s)"]
  end

  it "should return false if there are more items in the array than what is defined in the tuple" do
    @schema.validate?([1,2,3]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["base"].must_equal ["expected at most 2 item(s) but got 3 item(s)"]
  end

  it "should return false if any of the items are not the correct type specified for that index" do
    @schema.validate?([1, "hello"]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["base"].must_equal ["wrong type at index 1"]
  end

  it "should return true if the items in the array match their defined type" do
    @schema.validate?([1, 2]).must_equal true
    @schema.errors.size.must_equal 0
  end
end

describe ObjectSchemas::Schemas::ArraySchema, "tuple validation (with optional items)" do
  before do
    @schema = ObjectSchemas::Schemas::ArraySchema.define do |s|
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

  it "should return false if there are no items in the array" do
    @schema.validate?([]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["base"].must_equal ["expected at least 2 item(s) but got 0 item(s)"]
  end

  it "should return false if there are fewer items in the array than what is defined in the tuple" do
    @schema.validate?([1]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["base"].must_equal ["expected at least 2 item(s) but got 1 item(s)"]
  end

  it "should return true if we have extended beyond the required tuple items and into the optional items" do
    @schema.validate?([1,2,3,4]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return false if there are more items in the array than what is defined in the tuple (including the optional items)" do
    @schema.validate?([1,2,3,4,5]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["base"].must_equal ["expected at most 4 item(s) but got 5 item(s)"]
  end

  it "should return false if any of the required items are not the correct type specified for that index" do
    @schema.validate?([1, "hello"]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["base"].must_equal ["wrong type at index 1"]
  end

  it "should return false if any of the optional items are not the correct type specified for that index" do
    @schema.validate?([1,2,"hello"]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["base"].must_equal ["wrong type at index 2"]
  end

  it "should return true if the items in the array match their defined type" do
    @schema.validate?([1,2,3,4]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return true if we only have the required items in the array" do
    @schema.validate?([1,2]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return true if we only have some of the optional items in the array" do
    @schema.validate?([1,2,3]).must_equal true
    @schema.errors.size.must_equal 0
  end
end

describe ObjectSchemas::Schemas::ArraySchema, "tuple validation (all optional items)" do
  before do
    @schema = ObjectSchemas::Schemas::ArraySchema.define do |s|
      s.optional_items do |y|
        y.integer
        y.always_right_type
      end
    end
  end

  it "should return true if there are no items in the array" do
    @schema.validate?([]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return true if there are fewer items in the array than what is defined in the tuple" do
    @schema.validate?([1]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return false if there are more items in the array than what is defined in the tuple" do
    @schema.validate?([1,2,3]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["base"].must_equal ["expected at most 2 item(s) but got 3 item(s)"]
  end

  it "should return false if any of the items are not the correct type specified for that index" do
    @schema.validate?(["hello",2]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["base"].must_equal ["wrong type at index 0"]
  end

  it "should return true if the items in the array match their defined type" do
    @schema.validate?([1,2]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return true if we only have some of the optional items in the array" do
    @schema.validate?([1]).must_equal true
    @schema.errors.size.must_equal 0
  end
end

describe ObjectSchemas::Schemas::ArraySchema, "validating uniqueness" do
  it "should return false if there were duplicates in a single-type array" do
    schema = ObjectSchemas::Schemas::ArraySchema.define :validates_uniqueness => true do |s|
      s.integer
    end

    schema.validate?([1,2,1]).must_equal false
    schema.errors.size.must_equal 1
    schema.errors["base"].must_equal ["duplicate items are not allowed"]
  end

  it "should return false if there were duplicates in a tuple array (no optional items)" do
    schema = ObjectSchemas::Schemas::ArraySchema.define :validates_uniqueness => true do |s|
      s.items do |x|
        x.integer
        x.integer
        x.integer
      end
    end

    schema.validate?([1,2,1]).must_equal false
    schema.errors.size.must_equal 1
    schema.errors["base"].must_equal ["duplicate items are not allowed"]
  end

  it "should return false if there were duplicates in a tuple array (with optional items)" do
    schema = ObjectSchemas::Schemas::ArraySchema.define :validates_uniqueness => true do |s|
      s.items do |x|
        x.integer
        x.integer
      end

      s.optional_items do |x|
        x.integer
      end
    end

    schema.validate?([1,2,1]).must_equal false
    schema.errors.size.must_equal 1
    schema.errors["base"].must_equal ["duplicate items are not allowed"]
  end

  it "should return false if there were duplicates in a tuple array (all optional items)" do
    schema = ObjectSchemas::Schemas::ArraySchema.define :validates_uniqueness => true do |s|
      s.optional_items do |x|
        x.integer
        x.integer
        x.integer
      end
    end

    schema.validate?([1,2,1]).must_equal false
    schema.errors.size.must_equal 1
    schema.errors["base"].must_equal ["duplicate items are not allowed"]
  end
end

describe ObjectSchemas::Schemas::ArraySchema, "validating minimum size" do
  it "should return false if there were not enough items in a single-type array" do
    schema = ObjectSchemas::Schemas::ArraySchema.define :min_size => 3 do |s|
      s.integer
    end

    schema.validate?([1,2]).must_equal false
    schema.errors.size.must_equal 1
    schema.errors["base"].must_equal ["expected at least 3 item(s) but got 2 item(s)"]
  end

  it "should return true if there were just enough items in a single-type array" do
    schema = ObjectSchemas::Schemas::ArraySchema.define :min_size => 3 do |s|
      s.integer
    end

    schema.validate?([1,2,3]).must_equal true
    schema.errors.size.must_equal 0
  end

  it "should return true if there were more than enough items in a single-type array" do
    schema = ObjectSchemas::Schemas::ArraySchema.define :min_size => 3 do |s|
      s.integer
    end

    schema.validate?([1,2,3,4]).must_equal true
    schema.errors.size.must_equal 0
  end
end

describe ObjectSchemas::Schemas::ArraySchema, "validating maximum size" do
  it "should return false if there were too many items in a single-type array" do
    schema = ObjectSchemas::Schemas::ArraySchema.define :max_size => 3 do |s|
      s.integer
    end

    schema.validate?([1,2,3,4]).must_equal false
    schema.errors.size.must_equal 1
    schema.errors["base"].must_equal ["expected at most 3 item(s) but got 4 item(s)"]
  end

  it "should return true if we were at the limit of items in a single-type array" do
    schema = ObjectSchemas::Schemas::ArraySchema.define :max_size => 3 do |s|
      s.integer
    end

    schema.validate?([1,2,3]).must_equal true
    schema.errors.size.must_equal 0
  end

  it "should return true if we were not close to the limit in a single-type array" do
    schema = ObjectSchemas::Schemas::ArraySchema.define :max_size => 3 do |s|
      s.integer
    end

    schema.validate?([1]).must_equal true
    schema.errors.size.must_equal 0
  end
end

describe ObjectSchemas::Schemas::ArraySchema, "validating minimum and maximum size" do
  before do
    @schema = ObjectSchemas::Schemas::ArraySchema.define :min_size => 3, :max_size => 5 do |s|
      s.integer
    end
  end

  it "should return false if it is below the minimum" do
    @schema.validate?([1,2]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["base"].must_equal ["expected at least 3 item(s) but got 2 item(s)"]
  end

  it "should return false if it is above the maximum" do
    @schema.validate?([1,2,3,4,5,6]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["base"].must_equal ["expected at most 5 item(s) but got 6 item(s)"]
  end

  it "should return true if it is at the minimum" do
    @schema.validate?([1,2,3]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return true if it is at the maximum" do
    @schema.validate?([1,2,3,4,5]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return true if it is within the range" do
    @schema.validate?([1,2,3,4]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return true if the min and max are the same value" do
    schema = ObjectSchemas::Schemas::ArraySchema.define :min_size => 3, :max_size => 3 do |s|
      s.integer
    end
    schema.validate?([1,2,3]).must_equal true
    schema.errors.size.must_equal 0
  end
end

describe ObjectSchemas::Schemas::ArraySchema, "validating `allow nil`" do
  it "should return false if nil is not allowed and a nil object is given" do
    schema = ObjectSchemas::Schemas::ArraySchema.define :allow_nil => false do |s|
      s.integer
    end
    schema.validate?(nil).must_equal false
    schema.errors.size.must_equal 1
    schema.errors["base"].must_equal ["nil object not allowed"]
  end

  it "should return true if nil is allowed and a nil object is given" do
    schema = ObjectSchemas::Schemas::ArraySchema.define :allow_nil => true do |s|
      s.integer
    end
    schema.validate?(nil).must_equal true
    schema.errors.size.must_equal 0
  end
end