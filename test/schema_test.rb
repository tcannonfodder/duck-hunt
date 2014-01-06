require File.expand_path('../test_helper', __FILE__)


describe ObjectSchemas::Schema do
	it "should be an abstract class" do
		lambda{
			ObjectSchemas::Schema.new
		}.must_raise(NoMethodError)
	end
end