require 'rspec/its'

begin
  gem 'simplecov'
  require 'simplecov'
  SimpleCov.start do
    add_filter '/test/'
    add_filter '/spec/'
    add_filter '/.vendor/'
    add_filter '/vendor/'
    add_filter '/gems/'
    add_filter '/node_modules/'
    add_filter '/coverage/'
    add_group 'Models', 'lib/puppet-herald/models'
    add_group 'App', 'lib/puppet-herald/app'
    minimum_coverage 95
    maximum_coverage_drop 3
    coverage_dir 'coverage/ruby'
  end
rescue Gem::LoadError
  # do nothing
end

begin
  gem 'coveralls'
  require 'coveralls'  
  if ENV['TRAVIS']
    Coveralls.wear!
  end
rescue Gem::LoadError
  # do nothing
end

begin
  gem 'pry'
  require 'pry'
rescue Gem::LoadError
  # do nothing
end

RSpec.configure do |c|
  c.expect_with :rspec do |mock|
    mock.syntax = [:expect, :should]
  end
end
