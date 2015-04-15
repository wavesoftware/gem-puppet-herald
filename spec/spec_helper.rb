require 'rspec/its'

begin
  gem 'simplecov'
  require 'simplecov'
  require 'simplecov-lcov'
  SimpleCov::Formatter::LcovFormatter.report_with_single_file = true
  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::LcovFormatter,
  ]
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
