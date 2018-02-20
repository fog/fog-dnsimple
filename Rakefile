require "bundler/gem_tasks"

task :default => :test


require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs = %w( lib test )
  t.pattern = "test/**/*_test.rb"
  t.verbose = !ENV["VERBOSE"].nil?
  t.warning = !ENV["WARNING"].nil?
end
