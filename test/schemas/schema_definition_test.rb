require File.expand_path('../../test_helper', __FILE__)

class SchemaDefinitionTestClass
  include ObjectSchemas::Schemas::SchemaDefinition

  attr_accessor :other_value

  def initialize
    self.other_value = "hello"
  end

  def setter!
    @value = 1
  end

  def getter
    @value
  end
end

describe ObjectSchemas::Schemas::SchemaDefinition, "defining an object through a block" do
  it "should accept a block through the `define` method and use it create a new instance of the class" do
    schema = SchemaDefinitionTestClass.define do |s|
      s.setter!
    end

    schema.must_be_instance_of SchemaDefinitionTestClass
    schema.getter.must_equal 1
  end

  it "should still call the `initialize` method defined in the class when `define` is used" do
    schema = SchemaDefinitionTestClass.define do |s|
      s.setter!
    end

    schema.must_be_instance_of SchemaDefinitionTestClass
    schema.getter.must_equal 1
    schema.other_value.must_equal "hello"
  end

  it "should default the `strict mode` to `false`" do
    schema = SchemaDefinitionTestClass.define do |s|
    end

    schema.must_be_instance_of SchemaDefinitionTestClass
    schema.strict_mode.must_equal false
    schema.strict_mode?.must_equal false
  end
end

describe ObjectSchemas::Schemas::SchemaDefinition, "defining an object without a block" do
  it "should default the strict mode to false" do
    schema = SchemaDefinitionTestClass.new
    schema.strict_mode.must_equal false
    schema.strict_mode?.must_equal false
  end

  it "should allow the strict mode to be set" do
    schema = SchemaDefinitionTestClass.new
    schema.strict!
    schema.strict_mode.must_equal true
    schema.strict_mode?.must_equal true
  end
end

describe ObjectSchemas::Schemas::SchemaDefinition, "Adding a property to the schema" do
  it "should raise a `NotImplementedError` if the property definition exists (classes using this module must implement `add_property`" do
    schema = SchemaDefinitionTestClass.new
    lambda {
      schema.test
    }.must_raise(NotImplementedError)
  end

  it "should raise NoMethodError if the property definition does not exist (it was not found)" do
    schema = SchemaDefinitionTestClass.new
    lambda {
      schema.herp
    }.must_raise(NoMethodError)
  end
end