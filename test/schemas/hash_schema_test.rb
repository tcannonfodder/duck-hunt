require File.expand_path('../../test_helper', __FILE__)


describe DuckHunt::Schemas::HashSchema, "defining an object through a block" do
	it "should be able to define a property in the schema" do
		schema = DuckHunt::Schemas::HashSchema.define do |s|
			s.test "name"
		end

		schema.properties.size.must_equal 1
		schema.properties["name"].wont_be_nil
		schema.properties["name"].required?.must_equal true
	end

	it "should be able to set the options of a property in the schema" do
		schema = DuckHunt::Schemas::HashSchema.define do |s|
			s.test "name", :required => false
		end

		schema.properties.size.must_equal 1
		schema.properties["name"].wont_be_nil
		schema.properties["name"].required?.must_equal false
	end

	it "should default the `strict mode` to `true`" do
    schema = DuckHunt::Schemas::HashSchema.define do |s|
    end

    schema.strict_mode.must_equal true
    schema.strict_mode?.must_equal true
  end

  it "should allow the strict mode to be set to false" do
    schema = DuckHunt::Schemas::HashSchema.define :strict_mode => false do |s|
    	s.test "name"
    end
    schema.strict_mode.must_equal false
    schema.strict_mode?.must_equal false
  end
end

describe DuckHunt::Schemas::HashSchema, "defining an object without a block" do
  it "should default the strict mode to true" do
    schema = DuckHunt::Schemas::HashSchema.new
    schema.strict_mode.must_equal true
    schema.strict_mode?.must_equal true
  end

  it "should allow the strict mode to be set to false" do
    schema = DuckHunt::Schemas::HashSchema.new(:strict_mode => false)
    schema.strict_mode.must_equal false
    schema.strict_mode?.must_equal false
  end
end


describe DuckHunt::Schemas::HashSchema, "defining properties" do
	it "should be able to add a new property to the schema, which is required by default" do
		schema = DuckHunt::Schemas::HashSchema.new
		schema.test "name"
		schema.properties.size.must_equal 1
		schema.properties["name"].wont_be_nil
		schema.properties["name"].required.must_equal true
		schema.properties["name"].required?.must_equal true
	end

	it "should allow a property to be explictly set as required" do
		schema = DuckHunt::Schemas::HashSchema.new
		schema.test "name", :required => true
		schema.test "item", "required" => true

		schema.properties.size.must_equal 2

		schema.properties["name"].wont_be_nil
		schema.properties["name"].required.must_equal true
		schema.properties["name"].required?.must_equal true
		schema.properties["item"].wont_be_nil
		schema.properties["item"].required.must_equal true
		schema.properties["item"].required?.must_equal true
	end

	it "should allow a property to be set as not required" do
		schema = DuckHunt::Schemas::HashSchema.new

		schema.test "name", :required => false
		schema.test "item", "required" => false

		schema.properties.size.must_equal 2
		schema.properties["name"].wont_be_nil
		schema.properties["name"].required.must_equal false
		schema.properties["name"].required?.must_equal false
		schema.properties["item"].wont_be_nil
		schema.properties["item"].required.must_equal false
		schema.properties["item"].required?.must_equal false
	end

	it "should require that properties are named" do
    schema = DuckHunt::Schemas::HashSchema.new
    lambda{
			schema.test
    }.must_raise(ArgumentError)

    lambda{
      schema.test ""
    }.must_raise(ArgumentError)
  end


	it "should prevent a property from being defined multiple times in a schema" do
		schema = DuckHunt::Schemas::HashSchema.new
		schema.test "name"

		lambda {
			schema.test "name"
		}.must_raise(DuckHunt::PropertyAlreadyDefined)
	end

	it "should ensure the list of properties cannot be modified" do
		schema = DuckHunt::Schemas::HashSchema.new
		schema.test "name"
		schema.properties.size.must_equal 1

		schema.properties["malicious"] = "muwah ha ha"
		schema.properties.size.must_equal 1

		lambda{
			schema.properties = {:malicious => "mwuah ha ha"}
		}.must_raise(NameError)
	end

	it "should ensure the list of required properties cannot be modified" do
		schema = DuckHunt::Schemas::HashSchema.new
		schema.test "name"
		lambda{
			schema.required_properties = {:malicious => "mwuah ha ha"}
		}.must_raise(NameError)
	end

  it "should pass a block down to the property being defined" do
    schema = DuckHunt::Schemas::HashSchema.new
    schema.test_block_passed "name" do
      1+1
    end

    schema.properties["name"].block_passed.must_equal true
  end
end

describe DuckHunt::Schemas::HashSchema, "validation (strict mode)" do
	it "should return false if the object provided is not a hash" do
		schema = DuckHunt::Schemas::HashSchema.define do |s|
			s.test "name"
		end

		schema.validate?("hello").must_equal false
		schema.errors.size.must_equal 1
		schema.errors["base"].must_equal ["wrong type"]
	end

	it "should return false if one of the properties is not valid" do
		schema = DuckHunt::Schemas::HashSchema.define do |s|
			s.always_wrong_type "name"
		end

		schema.validate?({:name => "hello"}).must_equal false
		schema.errors.size.must_equal 1
		schema.errors["name"].must_equal ["wrong type"]
	end

	it "should return false if the object is missing a required property" do
		schema = DuckHunt::Schemas::HashSchema.define do |s|
			s.test "name", :required => true
			s.always_right_type "hello", :required => false
		end

		schema.validate?({:hello => "hello"}).must_equal false
		schema.errors.size.must_equal 1
		schema.errors["name"].must_equal ["required"]
	end

	it "should return false if the schema has been set to strict mode and the hash provided has extra properties" do
		schema = DuckHunt::Schemas::HashSchema.define do |s|
			s.test "name", :required => true
		end

		schema.validate?({:name => "hello", :hello => "hello"}).must_equal false
		schema.errors.size.must_equal 1
		schema.errors["base"].must_equal ["has properties not defined in schema"]
	end

  it "should not retain the 'has properties not defined in schema' error message when validated twice" do
    schema = DuckHunt::Schemas::HashSchema.define do |s|
      s.always_right_type "name", :required => true
    end

    schema.validate?({:name => "hello", :hello => "hello"}).must_equal false
    schema.errors.size.must_equal 1
    schema.errors["base"].must_equal ["has properties not defined in schema"]

    schema.validate?({:name => "hello"}).must_equal true
    schema.errors.size.must_equal 0
  end
end

describe DuckHunt::Schemas::HashSchema, "validation (relaxed mode)" do
	it "should return false if the object provided is not a hash" do
		schema = DuckHunt::Schemas::HashSchema.define :strict_mode => false do |s|
			s.test "name"
		end

		schema.validate?("hello").must_equal false
		schema.errors.size.must_equal 1
		schema.errors["base"].must_equal ["wrong type"]
	end

	it "should return false if one of the properties is not valid" do
		schema = DuckHunt::Schemas::HashSchema.define :strict_mode => false do |s|
			s.always_wrong_type "name"
		end

		schema.validate?({:name => "hello"}).must_equal false
		schema.errors.size.must_equal 1
		schema.errors["name"].must_equal ["wrong type"]
	end

	it "should return false if the object is missing a required property" do
		schema = DuckHunt::Schemas::HashSchema.define :strict_mode => false do |s|
			s.test "name", :required => true
			s.always_right_type "hello", :required => false
		end

		schema.validate?({:hello => "hello"}).must_equal false
		schema.errors.size.must_equal 1
		schema.errors["name"].must_equal ["required"]
	end

	it "should return true if the schema has been set to relaxed mode and the hash provided has extra properties" do
		schema = DuckHunt::Schemas::HashSchema.define :strict_mode => false do |s|
			s.always_right_type "name", :required => true
		end

		schema.validate?({:name => "hello", :hello => "hello"}).must_equal true
		schema.errors.size.must_equal 0
	end
end

describe DuckHunt::Schemas::HashSchema, "validating `allow nil`" do
  it "should return false if nil is not allowed and a nil object is given" do
    schema = DuckHunt::Schemas::HashSchema.define :allow_nil => false do |s|
      s.test "name"
    end
    schema.validate?(nil).must_equal false
    schema.errors.size.must_equal 1
    schema.errors["base"].must_equal ["nil object not allowed"]
  end

  it "should return true if nil is allowed and a nil object is given" do
    schema = DuckHunt::Schemas::HashSchema.define :allow_nil => true do |s|
      s.test "name"
    end
    schema.validate?(nil).must_equal true
    schema.errors.size.must_equal 0
  end
end