require "rake/testtask"
require "bundler/gem_tasks"

desc "Default: run unit tests."
task :default => :test

Rake::TestTask.new do |t|
  t.libs << "lib" << "test"
  t.pattern = "test/**/*_test.rb"
end
