
require 'sinatra/activerecord/rake'
require 'rspec/core/rake_task'

desc "Run all spec tests at once."
RSpec::Core::RakeTask.new(:all)

desc "Run unit spec tests."
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = [
    'spec/unit'
  ]
end

desc "Run all spec tests at once."
RSpec::Core::RakeTask.new(:integration) do |t|
  t.pattern = [
    'spec/zzz_integration'
  ]
end

desc "Run lint, and spec tests."
task :test => [
  :all
]

task :default => :test