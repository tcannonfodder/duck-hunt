require File.expand_path('../../test_helper', __FILE__)


class DuckHuntHashSchemaDefiningThroughBlockTest < DuckHuntTestCase
	test "should be able to define a property in the schema" do
		schema = DuckHunt::Schemas::HashSchema.define do |s|
			s.test "name"
		end

		assert_equal 1, schema.properties.size
		assert_not_nil schema.properties["name"]
		assert_equal true, schema.properties["name"].required?
	end

	test "should be able to set the options of a property in the schema" do
		schema = DuckHunt::Schemas::HashSchema.define do |s|
			s.test "name", :required => false
		end

		assert_equal 1, schema.properties.size
		assert_not_nil schema.properties["name"]
		assert_equal false, schema.properties["name"].required?
	end

	test "should default the `strict mode` to `true`" do
    schema = DuckHunt::Schemas::HashSchema.define do |s|
    end

    assert_equal true, schema.strict_mode
    assert_equal true, schema.strict_mode?
  end

  test "should allow the strict mode to be set to false" do
    schema = DuckHunt::Schemas::HashSchema.define :strict_mode => false do |s|
    	s.test "name"
    end
    assert_equal false, schema.strict_mode
    assert_equal false, schema.strict_mode?
  end
end

class DuckHuntHashSchemaDefiningWithoutBlockTest < DuckHuntTestCase
  test "should default the strict mode to true" do
    schema = DuckHunt::Schemas::HashSchema.new
    assert_equal true, schema.strict_mode
    assert_equal true, schema.strict_mode?
  end

  test "should allow the strict mode to be set to false" do
    schema = DuckHunt::Schemas::HashSchema.new(:strict_mode => false)
    assert_equal false, schema.strict_mode
    assert_equal false, schema.strict_mode?
  end
end

class DuckHuntHashSchemaDefiningPropertiesTest < DuckHuntTestCase
	test "should be able to add a new property to the schema, which is required by default" do
		schema = DuckHunt::Schemas::HashSchema.new
		schema.test "name"
		assert_equal 1, schema.properties.size
		assert_not_nil schema.properties["name"]
		assert_equal true, schema.properties["name"].required
		assert_equal true, schema.properties["name"].required?
	end

	test "should allow a property to be explictly set as required" do
		schema = DuckHunt::Schemas::HashSchema.new
		schema.test "name", :required => true
		schema.test "item", "required" => true

		assert_equal 2, schema.properties.size

		assert_not_nil schema.properties["name"]
		assert_equal true, schema.properties["name"].required
		assert_equal true, schema.properties["name"].required?
		assert_not_nil schema.properties["item"]
		assert_equal true, schema.properties["item"].required
		assert_equal true, schema.properties["item"].required?
	end

	test "should allow a property to be set as not required" do
		schema = DuckHunt::Schemas::HashSchema.new

		schema.test "name", :required => false
		schema.test "item", "required" => false

		assert_equal 2, schema.properties.size
		assert_not_nil schema.properties["name"]
		assert_equal false, schema.properties["name"].required
		assert_equal false, schema.properties["name"].required?
		assert_not_nil schema.properties["item"]
		assert_equal false, schema.properties["item"].required
		assert_equal false, schema.properties["item"].required?
	end

	test "should require that properties are named" do
    schema = DuckHunt::Schemas::HashSchema.new
    assert_raises ArgumentError do
			schema.test
    end

    assert_raises ArgumentError do
      schema.test ""
    end
  end


	test "should prevent a property from being defined multiple times in a schema" do
		schema = DuckHunt::Schemas::HashSchema.new
		schema.test "name"

		assert_raises DuckHunt::PropertyAlreadyDefined do
			schema.test "name"
		end
	end

	test "should ensure the list of properties cannot be modified" do
		schema = DuckHunt::Schemas::HashSchema.new
		schema.test "name"
		assert_equal 1, schema.properties.size

		schema.properties["malicious"] = "muwah ha ha"
		assert_equal 1, schema.properties.size

		assert_raises NameError do
			schema.properties = {:malicious => "mwuah ha ha"}
		end
	end

	test "should ensure the list of required properties cannot be modified" do
		schema = DuckHunt::Schemas::HashSchema.new
		schema.test "name"

    assert_raises NameError do
			schema.required_properties = {:malicious => "mwuah ha ha"}
		end
	end

  test "should pass a block down to the property being defined" do
    schema = DuckHunt::Schemas::HashSchema.new
    schema.test_block_passed "name" do
      1+1
    end

    assert_equal true, schema.properties["name"].block_passed
  end
end

class DuckHuntHashSchemaStructModeValidationTest < DuckHuntTestCase
	test "should return false if the object provided is not a hash" do
		schema = DuckHunt::Schemas::HashSchema.define do |s|
			s.test "name"
		end

		assert_equal false, schema.validate?("hello")
		assert_equal 1, schema.errors.size
		assert_equal ["wrong type"], schema.errors["base"]
	end

	test "should return false if one of the properties is not valid" do
		schema = DuckHunt::Schemas::HashSchema.define do |s|
			s.always_wrong_type "name"
		end

		assert_equal false, schema.validate?({:name => "hello"})
		assert_equal 1, schema.errors.size
		assert_equal ["wrong type"], schema.errors["name"]
	end

	test "should return false if the object is missing a required property" do
		schema = DuckHunt::Schemas::HashSchema.define do |s|
			s.test "name", :required => true
			s.always_right_type "hello", :required => false
		end

		assert_equal false, schema.validate?({:hello => "hello"})
		assert_equal 1, schema.errors.size
		assert_equal ["required"], schema.errors["name"]
	end

	test "should return false if the schema has been set to strict mode and the hash provided has extra properties" do
		schema = DuckHunt::Schemas::HashSchema.define do |s|
			s.test "name", :required => true
		end

		assert_equal false, schema.validate?({:name => "hello", :hello => "hello"})
		assert_equal 1, schema.errors.size
		assert_equal ["has properties not defined in schema"], schema.errors["base"]
	end

  test "should not retain the 'has properties not defined in schema' error message when validated twice" do
    schema = DuckHunt::Schemas::HashSchema.define do |s|
      s.always_right_type "name", :required => true
    end

    assert_equal false, schema.validate?({:name => "hello", :hello => "hello"})
    assert_equal 1, schema.errors.size
    assert_equal ["has properties not defined in schema"], schema.errors["base"]

    assert_equal true, schema.validate?({:name => "hello"})
    assert_equal 0, schema.errors.size
  end
end

class DuckHuntHashSchemaRelaxedModeValidationTest < DuckHuntTestCase
	test "should return false if the object provided is not a hash" do
		schema = DuckHunt::Schemas::HashSchema.define :strict_mode => false do |s|
			s.test "name"
		end

		assert_equal false, schema.validate?("hello")
		assert_equal 1, schema.errors.size
		assert_equal ["wrong type"], schema.errors["base"]
	end

	test "should return false if one of the properties is not valid" do
		schema = DuckHunt::Schemas::HashSchema.define :strict_mode => false do |s|
			s.always_wrong_type "name"
		end

		assert_equal false, schema.validate?({:name => "hello"})
		assert_equal 1, schema.errors.size
		assert_equal ["wrong type"], schema.errors["name"]
	end

	test "should return false if the object is missing a required property" do
		schema = DuckHunt::Schemas::HashSchema.define :strict_mode => false do |s|
			s.test "name", :required => true
			s.always_right_type "hello", :required => false
		end

		assert_equal false, schema.validate?({:hello => "hello"})
		assert_equal 1, schema.errors.size
		assert_equal ["required"], schema.errors["name"]
	end

	test "should return true if the schema has been set to relaxed mode and the hash provided has extra properties" do
		schema = DuckHunt::Schemas::HashSchema.define :strict_mode => false do |s|
			s.always_right_type "name", :required => true
		end

		assert_equal true, schema.validate?({:name => "hello", :hello => "hello"})
		assert_equal 0, schema.errors.size
	end
end

class DuckHuntHashSchemaAllowNilValidationTest < DuckHuntTestCase
  test "should return false if nil is not allowed and a nil object is given" do
    schema = DuckHunt::Schemas::HashSchema.define :allow_nil => false do |s|
      s.test "name"
    end
    assert_equal false, schema.validate?(nil)
    assert_equal 1, schema.errors.size
    assert_equal ["nil object not allowed"], schema.errors["base"]
  end

  test "should return true if nil is allowed and a nil object is given" do
    schema = DuckHunt::Schemas::HashSchema.define :allow_nil => true do |s|
      s.test "name"
    end
    assert_equal true, schema.validate?(nil)
    assert_equal 0, schema.errors.size
  end
end