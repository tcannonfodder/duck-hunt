require File.expand_path('../../test_helper', __FILE__)

class PropertyLookupTestClass
  include ObjectSchemas::Schemas::PropertyLookup
end

class PropertyLookupBlockPassTestClass
  include ObjectSchemas::Schemas::PropertyLookup
  attr_reader :block_passed
  def add_property(property_constant, *args, &block)
    @block_passed = true if block_given?
  end
end

describe ObjectSchemas::Schemas::PropertyLookup, "Adding a property to the schema" do
  it "should raise a `NotImplementedError` if the property definition exists (classes using this module must implement `add_property`" do
    schema = PropertyLookupTestClass.new
    lambda {
      schema.test
    }.must_raise(NotImplementedError)
  end

  it "should raise NoMethodError if the property definition does not exist (it was not found)" do
    schema = PropertyLookupTestClass.new
    lambda {
      schema.herp
    }.must_raise(NoMethodError)
  end

  it "should pass the provided block down for property initializers to use" do
    schema = PropertyLookupBlockPassTestClass.new
    schema.test { 1+1 }
    schema.block_passed.must_equal true
  end

  it "should not break if a block is not provided" do
    schema = PropertyLookupBlockPassTestClass.new
    schema.test
    schema.block_passed.must_be_nil
  end
end