
require 'sinatra/activerecord/rake'
require 'rspec/core/rake_task'
require 'fileutils'

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

desc "Run javascript Jasmine/Karma tests on PhantomJS"
task :javascript do |t|
  FileUtils.rm_rf 'coverage/javascript'
  sh 'node_modules/karma/bin/karma start --browsers PhantomJS test/javascript/karma.conf.js'
  path = Pathname.glob('coverage/javascript/PhantomJS*/text.txt').first
  puts 'Coverage for Javascript:'
  puts File.read(path)
end

desc "Run lint, and spec tests."
task :test => [
  :all,
  :javascript
]

task :default => :test