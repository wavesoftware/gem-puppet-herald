# -*- encoding: utf-8 -*-

require File.expand_path('../lib/puppet-herald/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = PuppetHerald::PACKAGE
  gem.version       = PuppetHerald::VERSION
  gem.author        = 'Krzysztof Suszynski'
  gem.email         = 'krzysztof.suszynski@wavesoftware.pl'
  gem.license       = PuppetHerald::LICENSE
  gem.homepage      = PuppetHerald::HOMEPAGE
  gem.summary       = PuppetHerald::SUMMARY
  gem.description   = PuppetHerald::DESCRIPTION

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]

  # Dependencies
  gem.required_ruby_version = '>= 1.9.2'

  # Runtime
  gem.add_runtime_dependency 'rake',                 '~> 10.4'
  gem.add_runtime_dependency 'sinatra',              '~> 1.4'
  gem.add_runtime_dependency 'sinatra-contrib',      '~> 1.4'
  gem.add_runtime_dependency 'sinatra-activerecord', '~> 2.0'
  gem.add_runtime_dependency 'micro-optparse',       '~> 1.2'
  gem.add_runtime_dependency 'uglifier',             '~> 2.6'
  gem.add_runtime_dependency 'sqlite3',              '~> 1.3'
  gem.add_runtime_dependency 'pg',                   '~> 0.17'
  gem.add_runtime_dependency 'puma',                 '~> 2.10'

  # Test
  gem.add_development_dependency 'rspec',            '~> 3.1'
  gem.add_development_dependency 'rspec-its',        '~> 1.1'
  gem.add_development_dependency 'coveralls',        '~> 0.7'
  gem.add_development_dependency 'simplecov',        '~> 0.9'

  # Development
  gem.add_development_dependency 'inch',             '~> 0.5'
  gem.add_development_dependency 'travis',           '~> 1.6'
  gem.add_development_dependency 'pry-byebug',       '~> 2.0'   if RUBY_VERSION >= '2.0.0'
  gem.add_development_dependency 'pry-debugger',     '~> 0.2'   if RUBY_VERSION < '2.0.0'
  
end

# vim:ft=ruby