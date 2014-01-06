# add our ./lib path to the required path
$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

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
require 'object-schemas'