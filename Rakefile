require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
end

desc "Run tests"
task :default => :test


task :console do
  exec "irb -r duck-hunt -I ./lib"
end