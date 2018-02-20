require "bundler/gem_tasks"

task :default => [:test, :shindo]


require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs = %w( lib tests )
  t.pattern = "tests/**/*_test.rb"
  t.verbose = !ENV["VERBOSE"].nil?
  t.warning = !ENV["WARNING"].nil?
end
