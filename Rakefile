require "bundler/gem_tasks"

task :default => [:test, :minitest]

task :test do
  mock = ENV['FOG_MOCK'] || 'true'
  sh("export FOG_MOCK=#{mock} && bundle exec shindont")
end


require "rake/testtask"

Rake::TestTask.new(:minitest) do |t|
  t.libs = %w( lib tests )
  t.pattern = "tests/**/*_test.rb"
  t.verbose = !ENV["VERBOSE"].nil?
  t.warning = !ENV["WARNING"].nil?
end