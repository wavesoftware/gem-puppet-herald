source ENV['GEM_SOURCE'] || 'https://rubygems.org'

gemspec

group :test do
  gem 'rake',               '~> 10.4',  require: false
  gem 'rspec',              '~> 3.1',   require: false
  gem 'rspec-its',          '~> 1.1',   require: false
  gem 'webmock',            '~> 1.20',  require: false
  gem 'coveralls',          '~> 0.7',   require: false
  gem 'simplecov',          '~> 0.9',   require: false
  gem 'sqlite3',            '~> 1.3',   require: false
  gem 'rubocop',            '~> 0.28',  require: false
  gem 'rspec-activerecord', '~> 0.0.2', require: false
  gem 'ox',                 '~> 2.1.4', require: false
end

group :development do
  gem 'guard',            '~> 2.12', require: false
  gem 'guard-bundler',    '~> 2.1',  require: false
  gem 'guard-rspec',      '~> 4.5',  require: false
  gem 'guard-rake',       '~> 1.0',  require: false
  gem 'guard-shell',      '~> 0.7',  require: false
  gem 'guard-rubocop',    '~> 1.2',  require: false
  gem 'inch',             '~> 0.5',  require: false
  gem 'travis',           '~> 1.6',  require: false
  gem 'pry-byebug',       '~> 2.0',  require: false   if RUBY_VERSION >= '2.0.0'
  gem 'pry-debugger',     '~> 0.2',  require: false   if RUBY_VERSION < '2.0.0'
end

local_gemfile = File.join(File.dirname(__FILE__), 'Gemfile.local')
eval_gemfile local_gemfile if File.exist?(local_gemfile)

begin
  npmbin = `npm bin`.strip
  ENV['PATH'] = "#{npmbin}:#{ENV['PATH']}"
rescue # rubocop:disable Lint/HandleExceptions
  # nothing
end
# vim:ft=ruby
