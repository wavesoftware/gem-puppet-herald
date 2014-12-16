
require 'sinatra/activerecord/rake'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'fileutils'

desc "Run all spec tests at once."
RSpec::Core::RakeTask.new(:"spec:all")

desc "Run unit spec tests."
RSpec::Core::RakeTask.new(:"spec:unit") do |t|
  t.pattern = [
    'spec/unit'
  ]
end

desc "Run integration spec tests."
RSpec::Core::RakeTask.new(:"spec:integration") do |t|
  t.pattern = [
    'spec/zzz_integration'
  ]
end

desc "Run javascript Jasmine/Karma tests on PhantomJS."
task :js do |t|
  FileUtils.rm_rf 'coverage/javascript'
  sh 'node_modules/karma/bin/karma start --browsers PhantomJS test/javascript/karma.conf.js'
  path = Pathname.glob('coverage/javascript/PhantomJS*/text.txt').first
  puts 'Coverage for Javascript:'
  puts File.read(path)
end

tests = [
  :rubocop,
  :"spec:all",
  :js
]

begin
  require 'inch/rake'
  Inch::Rake::Suggest.new :inch
  tests << :inch
rescue LoadError
  # nothing here
end

RuboCop::RakeTask.new(:rubocop) do |task|
  # don't abort rake on failure
  task.fail_on_error = true
end

desc "Run lint, and all spec tests."
task :test => tests

task :default => :test