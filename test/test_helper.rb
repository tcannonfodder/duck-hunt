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
require 'minitest/spec'
require 'minitest/pride'
require 'mocha'
require 'set'
require 'object-schemas'

#require some basic test classes (useful for testing modules independently)
require 'test_helper/test_classes'