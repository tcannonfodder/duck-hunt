require File.expand_path('../../test_helper', __FILE__)

describe DuckHunt::Properties::NestedHash, "initialize using a block" do
  it "should be able to set the property to required" do
    property = DuckHunt::Properties::NestedHash.new :required => true do |s|
      s.test "name"
    end
    property.required.must_equal true
    property.required?.must_equal true
  end

  it "should be able to define the property" do
    property = DuckHunt::Properties::NestedHash.new :required => true do |s|
      s.test "name"
    end

    property.properties["name"].must_be_instance_of DuckHunt::Properties::Test
  end

  it "should be able to set options for the property" do
    property = DuckHunt::Properties::NestedHash.new :strict_mode => false do |s|
      s.test "name"
    end

    property.strict_mode?.must_equal false
  end

  it "should be able to set property-level and property-level options at the same time" do
    property = DuckHunt::Properties::NestedHash.new :required => true, :strict_mode => false do |s|
      s.test "name"
    end
    property.required.must_equal true
    property.required?.must_equal true
    property.strict_mode?.must_equal false
  end

  it "should default the `strict mode` to `true`" do
    property = DuckHunt::Properties::NestedHash.new do |s|
    end

    property.strict_mode.must_equal true
    property.strict_mode?.must_equal true
  end

end

describe DuckHunt::Properties::NestedHash, "initialize without a block" do
  it "should raise an exception if a block is not provided" do
    lambda{
     DuckHunt::Properties::NestedHash.new :required => false
    }.must_raise(ArgumentError)
  end
end

describe DuckHunt::Properties::NestedHash, "defining properties" do
  it "should be able to add a new property to the property, which is required by default" do
    property = DuckHunt::Properties::NestedHash.new do |s|
      s.test "name"
    end

    property.properties.size.must_equal 1
    property.properties["name"].wont_be_nil
    property.properties["name"].required.must_equal true
    property.properties["name"].required?.must_equal true
  end

  it "should allow a property to be explictly set as required" do
    property = DuckHunt::Properties::NestedHash.new do |s|
      s.test "name", :required => true
      s.test "item", "required" => true
    end

    property.properties.size.must_equal 2

    property.properties["name"].wont_be_nil
    property.properties["name"].required.must_equal true
    property.properties["name"].required?.must_equal true
    property.properties["item"].wont_be_nil
    property.properties["item"].required.must_equal true
    property.properties["item"].required?.must_equal true
  end

  it "should allow a property to be set as not required" do
    property = DuckHunt::Properties::NestedHash.new do |s|
      s.test "name", :required => false
      s.test "item", "required" => false
    end

    property.properties.size.must_equal 2
    property.properties["name"].wont_be_nil
    property.properties["name"].required.must_equal false
    property.properties["name"].required?.must_equal false
    property.properties["item"].wont_be_nil
    property.properties["item"].required.must_equal false
    property.properties["item"].required?.must_equal false
  end

  it "should require that properties are named" do
    lambda{
      DuckHunt::Properties::NestedHash.new do |s|
        s.test
      end
    }.must_raise(ArgumentError)

    lambda{
      DuckHunt::Properties::NestedHash.new do |s|
        s.test ""
      end
    }.must_raise(ArgumentError)
  end


  it "should prevent a property from being defined multiple times in a property" do
    lambda {
      property = DuckHunt::Properties::NestedHash.new do |s|
        s.test "name"
        s.test "name"
      end
    }.must_raise(DuckHunt::PropertyAlreadyDefined)
  end

  it "should ensure the list of properties cannot be modified" do
    property = DuckHunt::Properties::NestedHash.new do |s|
      s.test "name"
    end

    property.properties.size.must_equal 1

    property.properties["malicious"] = "muwah ha ha"
    property.properties.size.must_equal 1

    lambda{
      property.properties = {:malicious => "mwuah ha ha"}
    }.must_raise(NoMethodError)
  end

  it "should ensure the list of required properties cannot be modified" do
    property = DuckHunt::Properties::NestedHash.new do |s|
      s.test "name"
    end

    lambda{
      property.required_properties = {:malicious => "mwuah ha ha"}
    }.must_raise(NoMethodError)
  end
end

describe DuckHunt::Properties::NestedHash, "validation (strict mode)" do
  it "should return false if the object provided is not a hash" do
    property = DuckHunt::Properties::NestedHash.new do |s|
      s.test "name"
    end

    property.valid?("hello").must_equal false
    property.errors.size.must_equal 1
    property.errors["base"].must_equal ["wrong type"]
  end

  it "should return false if one of the properties is not valid" do
    property = DuckHunt::Properties::NestedHash.new do |s|
      s.always_wrong_type "name"
    end

    property.valid?({:name => "hello"}).must_equal false
    property.errors.size.must_equal 1
    property.errors["name"].must_equal ["wrong type"]
  end

  it "should return false if the object is missing a required property" do
    property = DuckHunt::Properties::NestedHash.new do |s|
      s.test "name", :required => true
      s.always_right_type "hello", :required => false
    end

    property.valid?({:hello => "hello"}).must_equal false
    property.errors.size.must_equal 1
    property.errors["name"].must_equal ["required"]
  end

  it "should return false if the property has been set to strict mode and the hash provided has extra properties" do
    property = DuckHunt::Properties::NestedHash.new do |s|
      s.test "name", :required => true
    end

    property.valid?({:name => "hello", :hello => "hello"}).must_equal false
    property.errors.size.must_equal 1
    property.errors["base"].must_equal ["has properties not defined in schema"]
  end
end

describe DuckHunt::Properties::NestedHash, "validation (relaxed mode)" do
  it "should return false if the object provided is not a hash" do
    property = DuckHunt::Properties::NestedHash.new :strict_mode => false do |s|
      s.test "name"
    end

    property.valid?("hello").must_equal false
    property.errors.size.must_equal 1
    property.errors["base"].must_equal ["wrong type"]
  end

  it "should return false if one of the properties is not valid" do
    property = DuckHunt::Properties::NestedHash.new :strict_mode => false do |s|
      s.always_wrong_type "name"
    end

    property.valid?({:name => "hello"}).must_equal false
    property.errors.size.must_equal 1
    property.errors["name"].must_equal ["wrong type"]
  end

  it "should return false if the object is missing a required property" do
    property = DuckHunt::Properties::NestedHash.new :strict_mode => false do |s|
      s.test "name", :required => true
      s.always_right_type "hello", :required => false
    end

    property.valid?({:hello => "hello"}).must_equal false
    property.errors.size.must_equal 1
    property.errors["name"].must_equal ["required"]
  end

  it "should return true if the property has been set to relaxed mode and the hash provided has extra properties" do
    property = DuckHunt::Properties::NestedHash.new :strict_mode => false do |s|
      s.always_right_type "name", :required => true
    end

    property.valid?({:name => "hello", :hello => "hello"}).must_equal true
    property.errors.size.must_equal 0
  end
end

describe DuckHunt::Properties::NestedHash, "validating `allow nil`" do
  it "should return false if nil is not allowed and a nil object is given" do
    property = DuckHunt::Properties::NestedHash.new :allow_nil => false do |s|
      s.test "name"
    end
    property.valid?(nil).must_equal false
    property.errors.size.must_equal 1
    property.errors["base"].must_equal ["nil object not allowed"]
  end

  it "should return true if nil is allowed and a nil object is given" do
    property = DuckHunt::Properties::NestedHash.new :allow_nil => true do |s|
      s.test "name"
    end
    property.valid?(nil).must_equal true
    property.errors.size.must_equal 0
  end
end

describe DuckHunt::Properties::NestedHash, "Nesting in single-type array schemas" do
  before do
    @schema = DuckHunt::Schemas::ArraySchema.define do |s|
      s.nested_hash do |s|
        s.always_right_type "name", :required => true
      end
    end
  end

  it "should be able to be nested in an array schema" do
    @schema.single_type_property.must_be_instance_of DuckHunt::Properties::NestedHash
  end

  it "should return true if the nested hashes are valid" do
    @schema.validate?([{:name => "Hello"}, {:name => "World"}]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return false if one of the nested hashes is invalid" do
    @schema.validate?([{:name => "Hello"}, {:world => "World"}]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["1"].must_equal({"base" => ["has properties not defined in schema"]})

    @schema.validate?([{:name => "Hello"}, {}]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["1"].must_equal({"name" => ["required"]})
  end

  it "should return false if both of the nested hashes are invalid" do
    @schema.validate?([{}, {}]).must_equal false
    @schema.errors.size.must_equal 2
    @schema.errors["0"].must_equal({"name" => ["required"]})
    @schema.errors["1"].must_equal({"name" => ["required"]})
  end
end

describe DuckHunt::Properties::NestedHash, "Nesting in tuple array schemas (no optional properties)" do
  before do
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

  it "should be able to be nested in an array schema" do
    @schema.tuple_properties.each{|x| x.must_be_instance_of DuckHunt::Properties::NestedHash}
  end

  it "should return true if the nested hashes are valid" do
    @schema.validate?([{:name => "Hello"}, {:age => "World"}]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return false if one of the nested hashes is invalid" do
    @schema.validate?([{:name => "Hello"}, {:world => "World"}]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["1"].must_equal({"base" => ["has properties not defined in schema"]})

    @schema.validate?([{:name => "Hello"}, {}]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["1"].must_equal({"age" => ["required"]})
  end

  it "should return false if both of the nested hashes are invalid" do
    @schema.validate?([{}, {}]).must_equal false
    @schema.errors.size.must_equal 2
    @schema.errors["0"].must_equal({"name" => ["required"]})
    @schema.errors["1"].must_equal({"age" => ["required"]})
  end
end

describe DuckHunt::Properties::NestedHash, "Nesting in tuple array schemas (with optional properties)" do
  before do
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

  it "should be able to be nested in an array schema" do
    @schema.tuple_properties.each{|x| x.must_be_instance_of DuckHunt::Properties::NestedHash}
    @schema.optional_tuple_properties.each{|x| x.must_be_instance_of DuckHunt::Properties::NestedHash}
  end

  it "should return true if the nested hashes are valid" do
    @schema.validate?([{:name => "Hello"}, {:age => "World"}]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return true if only the required hashes are provided" do
    @schema.validate?([{:name => "Hello"}]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return false if one of the nested hashes is invalid" do
    @schema.validate?([{:name => "Hello"}, {:world => "World"}]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["1"].must_equal({"base" => ["has properties not defined in schema"]})

    @schema.validate?([{:name => "Hello"}, {}]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["1"].must_equal({"age" => ["required"]})
  end

  it "should return false if both of the nested hashes are invalid" do
    @schema.validate?([{}, {}]).must_equal false
    @schema.errors.size.must_equal 2
    @schema.errors["0"].must_equal({"name" => ["required"]})
    @schema.errors["1"].must_equal({"age" => ["required"]})
  end
end

describe DuckHunt::Properties::NestedHash, "Nesting in tuple array schemas (all optional properties)" do
  before do
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

  it "should be able to be nested in an array schema" do
    @schema.optional_tuple_properties.each{|x| x.must_be_instance_of DuckHunt::Properties::NestedHash}
  end

  it "should return true if the nested hashes are valid" do
    @schema.validate?([{:name => "Hello"}, {:age => "World"}]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return true if no hashes are provided" do
    @schema.validate?([]).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return false if one of the nested hashes is invalid" do
    @schema.validate?([{:name => "Hello"}, {:world => "World"}]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["1"].must_equal({"base" => ["has properties not defined in schema"]})

    @schema.validate?([{}, {:age => "World"}]).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["0"].must_equal({"name" => ["required"]})
  end

  it "should return false if both of the nested hashes are invalid" do
    @schema.validate?([{}, {}]).must_equal false
    @schema.errors.size.must_equal 2
    @schema.errors["0"].must_equal({"name" => ["required"]})
    @schema.errors["1"].must_equal({"age" => ["required"]})
  end
end

describe DuckHunt::Properties::NestedHash, "Nesting in hashes" do
  before do
    @schema = DuckHunt::Schemas::HashSchema.define do |s|
      s.nested_hash "profile" do |x|
        x.always_right_type "name", :required => true
      end

      s.nested_hash "info" do |x|
        x.always_right_type "age", :required => true
      end
    end
  end

  it "should be able to be nested in an array schema" do
    @schema.properties["profile"].must_be_instance_of DuckHunt::Properties::NestedHash
  end

  it "should return true if the nested hashes are valid" do
    @schema.validate?({:profile => {:name => "John"}, :info => {:age => 35}}).must_equal true
    @schema.errors.size.must_equal 0
  end

  it "should return false if one of the nested hashes is invalid" do
    @schema.validate?({:profile => {:name => "John"}, :info => {:birthdate => 35}}).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["info"].must_equal({"base" => ["has properties not defined in schema"]})

    @schema.validate?({:profile => {:name => "John"}, :info => {}}).must_equal false
    @schema.errors.size.must_equal 1
    @schema.errors["info"].must_equal({"age" => ["required"]})
  end

  it "should return false if both of the nested hashes are invalid" do
    @schema.validate?({:profile => {}, :info => {}}).must_equal false
    @schema.errors.size.must_equal 2
    @schema.errors["profile"].must_equal({"name" => ["required"]})
    @schema.errors["info"].must_equal({"age" => ["required"]})
  end
end