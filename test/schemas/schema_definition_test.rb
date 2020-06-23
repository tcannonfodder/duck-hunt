require File.expand_path('../../test_helper', __FILE__)

class DuckHuntSchemaDefinitionThroughABlockTest < DuckHuntTestCase
  class SchemaDefinitionTestClass
    include DuckHunt::Schemas::SchemaDefinition

    attr_accessor :other_value

    def initialize(options=nil)
      self.other_value = "hello"
      self.other_value = options unless options.nil?
    end

    def setter!
      @value = 1
    end

    def getter
      @value
    end
  end

  test "should accept a block through the `define` method and use it create a new instance of the class and call instance methods" do
    schema = SchemaDefinitionTestClass.define do |s|
      s.setter!
    end

    assert_instance_of SchemaDefinitionTestClass, schema
    assert_equal 1, schema.getter
  end

  test "should still call the `initialize` method defined in the class when `define` is used" do
    schema = SchemaDefinitionTestClass.define do |s|
      s.setter!
    end

    assert_instance_of SchemaDefinitionTestClass, schema
    assert_equal 1, schema.getter
    assert_equal "hello", schema.other_value
  end

  test "should pass initialization parameters to the class when `define` is used" do
    schema = SchemaDefinitionTestClass.define "neato!" do |s|
      s.setter!
    end

    assert_instance_of SchemaDefinitionTestClass, schema
    assert_equal 1, schema.getter
    assert_equal "neato!", schema.other_value
  end
end