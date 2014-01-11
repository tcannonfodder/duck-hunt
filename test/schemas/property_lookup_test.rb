require File.expand_path('../../test_helper', __FILE__)

class PropertyLookupTestClass
  include ObjectSchemas::Schemas::PropertyLookup
end

describe ObjectSchemas::Schemas::SchemaDefinition, "Adding a property to the schema" do
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
end