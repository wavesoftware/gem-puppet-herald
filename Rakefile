
require 'sinatra/activerecord/rake'
require 'rspec/core/rake_task'

desc "Run spec tests."
RSpec::Core::RakeTask.new(:spec)

desc "Run lint, and spec tests."
task :test => [
  :spec
]

task :default => :test