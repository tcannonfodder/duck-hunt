require File.expand_path('../../test_helper', __FILE__)


class DuckHuntSchemaPropertyLookupTest < DuckHuntTestCase
  class PropertyLookupTestClass
    include DuckHunt::Schemas::PropertyLookup
  end

  class PropertyLookupBlockPassTestClass
    include DuckHunt::Schemas::PropertyLookup
    attr_reader :block_passed
    def add_property(property_constant, *args, &block)
      @block_passed = true if block_given?
    end
  end

  test "should raise a `NotImplementedError` if the property definition exists (classes using this module must implement `add_property`" do
    schema = PropertyLookupTestClass.new
    assert_raises NotImplementedError do
      schema.test
    end
  end

  test "should raise NoMethodError if the property definition does not exist (it was not found)" do
    schema = PropertyLookupTestClass.new
    assert_raises NoMethodError do
      schema.herp
    end
  end

  test "should pass the provided block down for property initializers to use" do
    schema = PropertyLookupBlockPassTestClass.new
    schema.test { 1+1 }
    assert_equal true, schema.block_passed
  end

  test "should not break if a block is not provided" do
    schema = PropertyLookupBlockPassTestClass.new
    schema.test
    assert_nil schema.block_passed
  end
end