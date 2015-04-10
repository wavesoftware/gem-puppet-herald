require 'jshintrb/jshinttask'
require 'sinatra/activerecord/rake'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'rubocop'
require 'fileutils'
require 'rainbow'

def cobertura_attrs
  require 'ox'
  f = File.open 'coverage/javascript/cobertura.xml'
  Ox.parse(f.read).root.attributes
end

def verify_js_coverage(line_expected = 0.9, branch_expected = 0.9)
  attrs = cobertura_attrs
  fail "Line coverage is #{attrs[:'line-rate'].to_f * 100}%, " \
    "that don't meet minimum requirements of #{line_expected * 100}%." if attrs[:'line-rate'].to_f < line_expected

  fail "Branch coverage is #{attrs[:'branch-rate'].to_f * 100}%, " \
    "that don't meet minimum requirements of #{branch_expected * 100}%." if attrs[:'branch-rate'].to_f < branch_expected
end

namespace :spec do
  desc 'Run all spec tests at once.'
  RSpec::Core::RakeTask.new(:all)

  desc 'Run unit spec tests.'
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = [
      'spec/unit'
    ]
  end

  desc 'Run integration spec tests.'
  RSpec::Core::RakeTask.new(:integration) do |t|
    t.pattern = [
      'spec/zzz_integration'
    ]
  end
end

namespace :js do
  desc 'Install NPM dependencies'
  task :install do
    sh 'npm install'
  end
  task :bower_standalone do
    Dir.chdir 'lib/puppet-herald/public' do
      sh 'bower install -p'
    end
    Dir.chdir 'test/javascript' do
      sh 'bower install'
    end
  end
  task :test_standalone do
    FileUtils.rm_rf 'coverage/javascript'
    sh 'node_modules/karma/bin/karma start --browsers PhantomJS test/javascript/karma.conf.js'
    path = Pathname.glob('coverage/javascript/text.txt').first
    puts Rainbow("\nCoverage for Javascript:\n").blue
    puts File.read(path)
    begin
      verify_js_coverage
    rescue StandardError => ex
      $stderr.puts Rainbow("\n#{ex.message} Write more tests!\n").red.bright
      exit 2
    end
  end
  Jshintrb::JshintTask.new :hint do |t|
    t.pattern = 'lib/puppet-herald/public/**/*.js'
    t.exclude_pattern = 'lib/puppet-herald/public/bower_components/**/*'
    t.options = :jshintrc
  end

  desc 'Install bower JS dependencies.'
  task bower: [:'js:install', :'js:bower_standalone']
  desc 'Run javascript Jasmine/Karma tests on PhantomJS.'
  task test: [:'js:install', :'js:bower', :'js:hint', :'js:test_standalone']
end

namespace :console do
  desc 'Start a console with loaded ActiveRecord models on dev database'
  task :db do
    require 'pry'
    require 'puppet-herald'
    PuppetHerald.environment = :dev
    home = File.expand_path('~')
    defaultdb     = "sqlite://#{home}/pherald.db"
    defaultdbpass = "#{home}/.pherald.pass"
    PuppetHerald.database.dbconn   = defaultdb
    PuppetHerald.database.passfile = defaultdbpass
    PuppetHerald.database.spec
    require 'puppet-herald/app/configuration'
    PuppetHerald::App::Configuration.configure_app(cron: false)
    require 'puppet-herald/models/node'
    pry
  end
end

tests = [
  :'js:test',
  :'spec:all',
  :rubocop
]

begin
  require 'inch/rake'
  Inch::Rake::Suggest.new :inch, '--pedantic'
  tests << :inch
rescue LoadError # rubocop:disable all
  # nothing here
end

RuboCop::RakeTask.new(:rubocop) do |task|
  # don't abort rake on failure
  task.fail_on_error = true
end

namespace :rubocop do
  namespace :todo do
    desc 'Cleans a rubocop TODO list'
    task :clean do
      File.write('.rubocop_todo.yml', '')
      Rake::Task[:rubocop].execute
    end

    desc 'Saves actual rubocop state into TODO list'
    task :save do
      rcli = RuboCop::CLI.new
      rcli.run ['--auto-gen-config']
    end
  end
end

desc 'Combine and POST covarage result to coveralls.io'
task :coveralls do
  root = File.dirname(File.expand_path(__FILE__))
  rlcov = File.read('./coverage/ruby/lcov/gem-puppet-herald.lcov').gsub("#{root}/", './')
  File.write('./coverage/ruby/lcov/lcov.info', rlcov)
  sh "./node_modules/.bin/lcov-result-merger 'coverage/*/lcov/lcov.info' | ./node_modules/coveralls/bin/coveralls.js"
end

tests << :inch if ENV['TRAVIS']

desc 'Run lint, and all spec tests.'
task test: tests

desc 'Installs all dependencies.'
task install: [:'js:install', :'js:bower']

desc 'Build a gem package.'
task :gem do
  sh 'gem build puppet-herald.gemspec'
end

desc 'Builds, and test package'
task build: [:install, :test, :gem]

task default: :test
