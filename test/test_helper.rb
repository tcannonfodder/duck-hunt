# add our ./lib path to the require paths
$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

# add our test path to the require paths (used when loading test helpers)
$: << File.expand_path(File.dirname(__FILE__))

# load our gems installed via Bundler
require 'rubygems'
require 'bundler/setup'

# try to load common debugging gems
["ruby-debug", "debugger"].each{|debugging_library|
	begin
  	require debugging_library
	rescue LoadError
  	# no big deal; it's only useful in development
	end
}

require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require 'set'
require 'bigdecimal'
require 'duck-hunt'

#require some basic test classes (useful for testing modules independently)
require 'test_helper/test_classes'

class DuckHuntTestCase < MiniTest::Test
  def assert_not_nil(value, message=nil)
    assert !value.nil?, message || "Expected value to not be nil"
  end

  def self.test(name, &block)
    test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
    defined = instance_method(test_name) rescue false
    raise "#{test_name} is already defined in #{self}" if defined
    if block_given?
      define_method(test_name, &block)
    else
      define_method(test_name) do
        flunk "No implementation provided for #{name}"
      end
    end
  end
end