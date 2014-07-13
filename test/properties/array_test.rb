require File.expand_path('../../test_helper', __FILE__)

describe DuckHunt::Properties::Array, "initialize using a block" do
  it "should be able to set the property to required" do
    property = DuckHunt::Properties::Array.new :required => true do |s|
      s.test
    end
    property.required.must_equal true
    property.required?.must_equal true
  end

  it "should be able to define a single-type array" do
    property = DuckHunt::Properties::Array.new do |s|
      s.integer
    end

    property.single_type_property.must_be_instance_of DuckHunt::Properties::Integer
    property.tuple_properties.must_be_nil
    property.optional_tuple_properties.must_be_nil
  end

  it "should be able to define a tuple array with no optional items" do
    property = DuckHunt::Properties::Array.new do |s|
      s.items do |x|
        x.integer
      end
    end

    property.tuple_properties.size.must_equal 1
    property.tuple_properties.first.must_be_instance_of DuckHunt::Properties::Integer

    property = DuckHunt::Properties::Array.new do |s|
      s.items do |x|
        x.integer
        x.test
      end
    end

    property.tuple_properties.size.must_equal 2
    property.tuple_properties.first.must_be_instance_of DuckHunt::Properties::Integer
    property.tuple_properties.last.must_be_instance_of DuckHunt::Properties::Test
  end

  it "should be able to define a tuple array with optional items" do
    property = DuckHunt::Properties::Array.new do |s|
      s.items do |x|
        x.integer
      end

      s.optional_items do |y|
        y.integer
        y.test
      end
    end

    property.tuple_properties.size.must_equal 1
    property.tuple_properties.first.must_be_instance_of DuckHunt::Properties::Integer

    property.optional_tuple_properties.size.must_equal 2
    property.optional_tuple_properties.first.must_be_instance_of DuckHunt::Properties::Integer
    property.optional_tuple_properties.last.must_be_instance_of DuckHunt::Properties::Test

    property = DuckHunt::Properties::Array.new do |s|
      s.items do |x|
        x.integer
        x.test
      end

      s.optional_items do |x|
        x.integer
      end
    end

    property.tuple_properties.size.must_equal 2
    property.tuple_properties.first.must_be_instance_of DuckHunt::Properties::Integer
    property.tuple_properties.last.must_be_instance_of DuckHunt::Properties::Test

    property.optional_tuple_properties.size.must_equal 1
    property.optional_tuple_properties.first.must_be_instance_of DuckHunt::Properties::Integer
  end

  it "should not allow single-type and tuple definitions in the same property" do
    lambda{
      property = DuckHunt::Properties::Array.new do |s|
        s.integer
        s.items do |x|
          x.integer
        end
      end
    }.must_raise DuckHunt::InvalidSchema

    lambda{
      property = DuckHunt::Properties::Array.new do |s|
        s.items do |x|
          x.integer
        end
        s.integer
      end
    }.must_raise DuckHunt::InvalidSchema

    lambda{
      property = DuckHunt::Properties::Array.new do |s|
        s.integer
        s.optional_items do |x|
          x.integer
        end
      end
    }.must_raise DuckHunt::InvalidSchema

    lambda{
      property = DuckHunt::Properties::Array.new do |s|
        s.optional_items do |x|
          x.integer
        end
        s.integer
      end
    }.must_raise DuckHunt::InvalidSchema
  end

  it "should be able to set options for the property" do
    property = DuckHunt::Properties::Array.new :min_size => 3 do |s|
      s.test
    end

    property.min_size.must_equal 3
  end

  it "should be able to set property-level and property-level options at the same time" do
    property = DuckHunt::Properties::Array.new :required => true, :min_size => 3 do |s|
      s.test
    end
    property.required.must_equal true
    property.required?.must_equal true
    property.min_size.must_equal 3
  end

  it "should require that a block be passed when setting tuple properties" do
    lambda{
      property = DuckHunt::Properties::Array.new do |s|
        s.items
      end
    }.must_raise ArgumentError

    lambda{
      property = DuckHunt::Properties::Array.new do |s|
        s.optional_items
      end
    }.must_raise ArgumentError
  end

  it "should allow the uniqueness flag to be set during initialization" do
    property = DuckHunt::Properties::Array.new :validates_uniqueness => true do |s|
      s.integer
    end

    property.validates_uniqueness?.must_equal true
    property.validates_uniqueness.must_equal true
  end

  it "should allow the min and max size to be set during initialization" do
    property = DuckHunt::Properties::Array.new :min_size => 10 do |s|
      s.integer
    end

    property.min_size.must_equal 10
    property.max_size.must_be_nil

    property = DuckHunt::Properties::Array.new :max_size => 10 do |s|
      s.integer
    end

    property.min_size.must_be_nil
    property.max_size.must_equal 10

    property = DuckHunt::Properties::Array.new :min_size => 5, :max_size => 10 do |s|
      s.integer
    end

    property.min_size.must_equal 5
    property.max_size.must_equal 10
  end

  it "should allow the 'allow nil' flag to be set during initialization" do
    property = DuckHunt::Properties::Array.new :allow_nil => true do |s|
      s.integer
    end

    property.allow_nil.must_equal true
    property.allow_nil?.must_equal true
  end

  it "should default the uniqueness flag to false" do
    property = DuckHunt::Properties::Array.new do |s|
      s.integer
    end

    property.validates_uniqueness.must_equal false
    property.validates_uniqueness?.must_equal false
  end

  it "should default the min and max size to nil" do
    property = DuckHunt::Properties::Array.new do |s|
      s.integer
    end

    property.min_size.must_be_nil
    property.max_size.must_be_nil
  end

  it "should default the 'allow nil' flag to false" do
    property = DuckHunt::Properties::Array.new do |s|
      s.integer
    end

    property.allow_nil.must_equal false
    property.allow_nil?.must_equal false
  end
end

describe DuckHunt::Properties::Array, "initialize without a block" do
  it "should raise an exception if a block is not provided" do
    lambda{
     DuckHunt::Properties::Array.new :required => false
    }.must_raise(ArgumentError)
  end
end

describe DuckHunt::Properties::Array, "single-type validation" do
  before do
    @property = DuckHunt::Properties::Array.new do |s|
      s.integer
    end
  end

  it "should return false if the object provided is not an array" do
    @property.valid?("hello").must_equal false
    @property.errors.size.must_equal 1
    @property.errors["base"].must_equal ["wrong type"]
  end

  it "should return true if there are no entries in the array" do
    @property.valid?([]).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should return true if every entry in the array is of the correct type" do
    @property.valid?([1,2,3]).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should return false if any entry in the array is not of the correct type, and have a base error mesage" do
    @property.valid?([1,"boo",3]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["1"].must_equal ["wrong type"]
  end

  it "should empty the errors array each time we validate" do
    @property.valid?([1,"boo",3]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["1"].must_equal ["wrong type"]

    @property.valid?(["boo",2,3]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["0"].must_equal ["wrong type"]
  end
end

describe DuckHunt::Properties::Array, "tuple validation (no optional items)" do
  before do
    @property = DuckHunt::Properties::Array.new do |s|
      s.items do |x|
        x.always_right_type
        x.integer
      end
    end
  end

  it "should return false if the object provided is not an array" do
    @property.valid?("hello").must_equal false
    @property.errors.size.must_equal 1
    @property.errors["base"].must_equal ["wrong type"]
  end

  it "should return false if there are no items in the array" do
    @property.valid?([]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["base"].must_equal ["expected at least 2 item(s) but got 0 item(s)"]
  end

  it "should return false if there are fewer items in the array than what is defined in the tuple" do
    @property.valid?([1]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["base"].must_equal ["expected at least 2 item(s) but got 1 item(s)"]
  end

  it "should return false if there are more items in the array than what is defined in the tuple" do
    @property.valid?([1,2,3]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["base"].must_equal ["expected at most 2 item(s) but got 3 item(s)"]
  end

  it "should return false if any of the items are not the correct type specified for that index" do
    @property.valid?([1, "hello"]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["1"].must_equal ["wrong type"]
  end

  it "should return true if the items in the array match their defined type" do
    @property.valid?([1, 2]).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should empty the errors array each time we validate" do
    @property.valid?([1, "hello"]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["1"].must_equal ["wrong type"]

    @property.valid?([1]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["base"].must_equal ["expected at least 2 item(s) but got 1 item(s)"]
  end
end

describe DuckHunt::Properties::Array, "tuple validation (with optional items)" do
  before do
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

  it "should return false if there are no items in the array" do
    @property.valid?([]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["base"].must_equal ["expected at least 2 item(s) but got 0 item(s)"]
  end

  it "should return false if there are fewer items in the array than what is defined in the tuple" do
    @property.valid?([1]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["base"].must_equal ["expected at least 2 item(s) but got 1 item(s)"]
  end

  it "should return true if we have extended beyond the required tuple items and into the optional items" do
    @property.valid?([1,2,3,4]).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should return false if there are more items in the array than what is defined in the tuple (including the optional items)" do
    @property.valid?([1,2,3,4,5]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["base"].must_equal ["expected at most 4 item(s) but got 5 item(s)"]
  end

  it "should return false if any of the required items are not the correct type specified for that index" do
    @property.valid?([1, "hello"]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["1"].must_equal ["wrong type"]
  end

  it "should return false if any of the optional items are not the correct type specified for that index" do
    @property.valid?([1,2,"hello"]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["2"].must_equal ["wrong type"]
  end

  it "should return true if the items in the array match their defined type" do
    @property.valid?([1,2,3,4]).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should return true if we only have the required items in the array" do
    @property.valid?([1,2]).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should return true if we only have some of the optional items in the array" do
    @property.valid?([1,2,3]).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should empty the errors array each time we validate" do
    @property.valid?([1, "hello"]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["1"].must_equal ["wrong type"]

    @property.valid?([1]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["base"].must_equal ["expected at least 2 item(s) but got 1 item(s)"]

    @property.valid?([1,2,"hello"]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["2"].must_equal ["wrong type"]
  end
end

describe DuckHunt::Properties::Array, "tuple validation (all optional items)" do
  before do
    @property = DuckHunt::Properties::Array.new do |s|
      s.optional_items do |y|
        y.integer
        y.always_right_type
      end
    end
  end

  it "should return true if there are no items in the array" do
    @property.valid?([]).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should return true if there are fewer items in the array than what is defined in the tuple" do
    @property.valid?([1]).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should return false if there are more items in the array than what is defined in the tuple" do
    @property.valid?([1,2,3]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["base"].must_equal ["expected at most 2 item(s) but got 3 item(s)"]
  end

  it "should return false if any of the items are not the correct type specified for that index" do
    @property.valid?(["hello",2]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["0"].must_equal ["wrong type"]
  end

  it "should return true if the items in the array match their defined type" do
    @property.valid?([1,2]).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should return true if we only have some of the optional items in the array" do
    @property.valid?([1]).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should empty the errors array each time we validate" do
    @property.valid?(["hello",2]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["0"].must_equal ["wrong type"]

    @property.valid?([1,2,3]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["base"].must_equal ["expected at most 2 item(s) but got 3 item(s)"]
  end
end

describe DuckHunt::Properties::Array, "validating uniqueness" do
  it "should return false if there were duplicates in a single-type array" do
    property = DuckHunt::Properties::Array.new :validates_uniqueness => true do |s|
      s.integer
    end

    property.valid?([1,2,1]).must_equal false
    property.errors.size.must_equal 1
    property.errors["base"].must_equal ["duplicate items are not allowed"]
  end

  it "should return false if there were duplicates in a tuple array (no optional items)" do
    property = DuckHunt::Properties::Array.new :validates_uniqueness => true do |s|
      s.items do |x|
        x.integer
        x.integer
        x.integer
      end
    end

    property.valid?([1,2,1]).must_equal false
    property.errors.size.must_equal 1
    property.errors["base"].must_equal ["duplicate items are not allowed"]
  end

  it "should return false if there were duplicates in a tuple array (with optional items)" do
    property = DuckHunt::Properties::Array.new :validates_uniqueness => true do |s|
      s.items do |x|
        x.integer
        x.integer
      end

      s.optional_items do |x|
        x.integer
      end
    end

    property.valid?([1,2,1]).must_equal false
    property.errors.size.must_equal 1
    property.errors["base"].must_equal ["duplicate items are not allowed"]
  end

  it "should return false if there were duplicates in a tuple array (all optional items)" do
    property = DuckHunt::Properties::Array.new :validates_uniqueness => true do |s|
      s.optional_items do |x|
        x.integer
        x.integer
        x.integer
      end
    end

    property.valid?([1,2,1]).must_equal false
    property.errors.size.must_equal 1
    property.errors["base"].must_equal ["duplicate items are not allowed"]
  end
end

describe DuckHunt::Properties::Array, "validating minimum size" do
  it "should return false if there were not enough items in a single-type array" do
    property = DuckHunt::Properties::Array.new :min_size => 3 do |s|
      s.integer
    end

    property.valid?([1,2]).must_equal false
    property.errors.size.must_equal 1
    property.errors["base"].must_equal ["expected at least 3 item(s) but got 2 item(s)"]
  end

  it "should return true if there were just enough items in a single-type array" do
    property = DuckHunt::Properties::Array.new :min_size => 3 do |s|
      s.integer
    end

    property.valid?([1,2,3]).must_equal true
    property.errors.size.must_equal 0
  end

  it "should return true if there were more than enough items in a single-type array" do
    property = DuckHunt::Properties::Array.new :min_size => 3 do |s|
      s.integer
    end

    property.valid?([1,2,3,4]).must_equal true
    property.errors.size.must_equal 0
  end
end

describe DuckHunt::Properties::Array, "validating maximum size" do
  it "should return false if there were too many items in a single-type array" do
    property = DuckHunt::Properties::Array.new :max_size => 3 do |s|
      s.integer
    end

    property.valid?([1,2,3,4]).must_equal false
    property.errors.size.must_equal 1
    property.errors["base"].must_equal ["expected at most 3 item(s) but got 4 item(s)"]
  end

  it "should return true if we were at the limit of items in a single-type array" do
    property = DuckHunt::Properties::Array.new :max_size => 3 do |s|
      s.integer
    end

    property.valid?([1,2,3]).must_equal true
    property.errors.size.must_equal 0
  end

  it "should return true if we were not close to the limit in a single-type array" do
    property = DuckHunt::Properties::Array.new :max_size => 3 do |s|
      s.integer
    end

    property.valid?([1]).must_equal true
    property.errors.size.must_equal 0
  end
end

describe DuckHunt::Properties::Array, "validating minimum and maximum size" do
  before do
    @property = DuckHunt::Properties::Array.new :min_size => 3, :max_size => 5 do |s|
      s.integer
    end
  end

  it "should return false if it is below the minimum" do
    @property.valid?([1,2]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["base"].must_equal ["expected at least 3 item(s) but got 2 item(s)"]
  end

  it "should return false if it is above the maximum" do
    @property.valid?([1,2,3,4,5,6]).must_equal false
    @property.errors.size.must_equal 1
    @property.errors["base"].must_equal ["expected at most 5 item(s) but got 6 item(s)"]
  end

  it "should return true if it is at the minimum" do
    @property.valid?([1,2,3]).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should return true if it is at the maximum" do
    @property.valid?([1,2,3,4,5]).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should return true if it is within the range" do
    @property.valid?([1,2,3,4]).must_equal true
    @property.errors.size.must_equal 0
  end

  it "should return true if the min and max are the same value" do
    property = DuckHunt::Properties::Array.new :min_size => 3, :max_size => 3 do |s|
      s.integer
    end
    property.valid?([1,2,3]).must_equal true
    property.errors.size.must_equal 0
  end
end

describe DuckHunt::Properties::Array, "validating `allow nil`" do
  it "should return false if nil is not allowed and a nil object is given" do
    property = DuckHunt::Properties::Array.new :allow_nil => false do |s|
      s.integer
    end
    property.valid?(nil).must_equal false
    property.errors.size.must_equal 1
    property.errors["base"].must_equal ["nil object not allowed"]
  end

  it "should return true if nil is allowed and a nil object is given" do
    property = DuckHunt::Properties::Array.new :allow_nil => true do |s|
      s.integer
    end
    property.valid?(nil).must_equal true
    property.errors.size.must_equal 0
  end
end

describe DuckHunt::Properties::Array, "Nesting in single-type array schemas" do
  before do
    @schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.array do |s|
        s.integer
      end
    end
  end

  it "should be able to be nested in an array schema" do
    @schema.single_type_property.must_be_instance_of DuckHunt::Properties::Array
  end

  it "should return true if the nested arrays are valid" do
    @schema.validate?([[1,2,3], [4,5,6]]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return false if one of the nested arrays is invalid" do
    @schema.validate?([[1,2,3], [4,"herp",6]]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["1"].must_equal({"1" => ["wrong type"]})
  end

  it "should return false if both of the nested arrays are invalid" do
    @schema.validate?([{}, {}]).must_equal false
    @schema.errors.size.must_equal 2
    @schema.errors["0"].must_equal({"base" => ["wrong type"]})
    @schema.errors["1"].must_equal({"base" => ["wrong type"]})
  end
end

describe DuckHunt::Properties::Array, "Nesting in tuple array schemas (no optional properties)" do
  before do
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

  it "should be able to be nested in an array schema" do
    @schema.tuple_properties.each{|x| x.must_be_instance_of DuckHunt::Properties::Array}
  end

  it "should return true if the nested arrays are valid" do
    @schema.validate?([[1,2,3], [4,5,6]]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return false if one of the nested arrays is invalid" do
    @schema.validate?([[1,2,3], [4,"herp",6]]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["1"].must_equal({"1" => ["wrong type"]})
  end

  it "should return false if both of the nested arrays are invalid" do
    @schema.validate?([{}, {}]).must_equal false
    @schema.errors.size.must_equal 2
    @schema.errors["0"].must_equal({"base" => ["wrong type"]})
    @schema.errors["1"].must_equal({"base" => ["wrong type"]})
  end
end

describe DuckHunt::Properties::Array, "Nesting in tuple array schemas (with optional properties)" do
  before do
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

  it "should be able to be nested in an array schema" do
    @schema.tuple_properties.each{|x| x.must_be_instance_of DuckHunt::Properties::Array}
    @schema.optional_tuple_properties.each{|x| x.must_be_instance_of DuckHunt::Properties::Array}
  end

  it "should return true if the nested arrays are valid" do
    @schema.validate?([[1,2,3], [4,5,6]]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return true if only the required arrays are provided" do
    @schema.validate?([[1,2,3]]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return false if one of the nested arrays is invalid" do
    @schema.validate?([[1,2,3], [4,"herp",6]]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["1"].must_equal({"1" => ["wrong type"]})

    @schema.validate?([[1,"herp",3], [4,5,6]]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["0"].must_equal({"1" => ["wrong type"]})
  end

  it "should return false if both of the nested arrays are invalid" do
    @schema.validate?([{}, {}]).must_equal false
    @schema.errors.size.must_equal 2
    @schema.errors["0"].must_equal({"base" => ["wrong type"]})
    @schema.errors["1"].must_equal({"base" => ["wrong type"]})
  end
end

describe DuckHunt::Properties::Array, "Nesting in tuple array schemas (all optional properties)" do
  before do
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

  it "should be able to be nested in an array schema" do
    @schema.optional_tuple_properties.each{|x| x.must_be_instance_of DuckHunt::Properties::Array}
  end

  it "should return true if the nested arrays are valid" do
    @schema.validate?([[1,2,3], [4,5,6]]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return true if no arrays are provided" do
    @schema.validate?([]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return false if one of the nested arrays is invalid" do
    @schema.validate?([[1,2,3], [4,"herp",6]]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["1"].must_equal({"1" => ["wrong type"]})
  end

  it "should return false if both of the nested arrays are invalid" do
    @schema.validate?([{}, {}]).must_equal false
    @schema.errors.size.must_equal 2
    @schema.errors["0"].must_equal({"base" => ["wrong type"]})
    @schema.errors["1"].must_equal({"base" => ["wrong type"]})
  end
end

describe DuckHunt::Properties::Array, "Nesting in hash" do
  before do
    @schema = DuckHunt::Schemas::HashSchema.define do |s|
      s.array "profile" do |x|
        x.integer
      end

      s.array "info" do |x|
        x.integer
      end
    end
  end

  it "should be able to be nested in a hash schema" do
    @schema.properties["profile"].must_be_instance_of DuckHunt::Properties::Array
  end

  it "should return true if the nested arrays are valid" do
    @schema.validate?({:profile => [1,2,3], :info => [4,5,6]}).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return false if one of the nested arrays is invalid" do
    @schema.validate?({:profile => [1,2,3], :info => {:birthdate => 35}}).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["info"].must_equal({"base" => ["wrong type"]})

    @schema.validate?({:profile => {:name => "John"}, :info => [4,5,6]}).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["profile"].must_equal({"base" => ["wrong type"]})
  end

  it "should return false if both of the nested arrays are invalid" do
    @schema.validate?({:profile => {}, :info => {}}).must_equal false
    @schema.errors.size.must_equal 2
    @schema.errors["profile"].must_equal({"base" => ["wrong type"]})
    @schema.errors["info"].must_equal({"base" => ["wrong type"]})
  end
end