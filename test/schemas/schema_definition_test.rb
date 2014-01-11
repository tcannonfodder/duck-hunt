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
  it "should accept a block through the `define` method and use it create a new instance of the class and call instance methods" do
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
end