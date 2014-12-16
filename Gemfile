source ENV['GEM_SOURCE'] || 'https://rubygems.org'

gemspec

group :test do
  gem 'rake',             '~> 10.4'
  gem 'rspec',            '~> 3.1'
  gem 'rspec-its',        '~> 1.1'
  gem 'coveralls',        '~> 0.7'
  gem 'simplecov',        '~> 0.9'
  gem 'sqlite3',          '~> 1.3'
  gem 'rubocop',          '~> 0.28'
end

group :development do
  gem 'inch',             '~> 0.5'
  gem 'travis',           '~> 1.6'
  gem 'pry-byebug',       '~> 2.0'   if RUBY_VERSION >= '2.0.0'
  gem 'pry-debugger',     '~> 0.2'   if RUBY_VERSION < '2.0.0'
end

local_gemfile = File.join(File.dirname(__FILE__), 'Gemfile.local')
if File.exist?(local_gemfile)
  eval_gemfile local_gemfile
end

# vim:ft=ruby
