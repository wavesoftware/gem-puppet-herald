require 'rspec/its'

begin
  gem 'simplecov'
  require 'simplecov'
  SimpleCov.start do
    add_filter "/test/"
    add_filter "/spec/"
    add_filter "/.vendor/"
    add_filter "/vendor/"
    add_filter "/gems/"
    add_filter "/node_modules/"
    add_filter "/coverage/"
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
