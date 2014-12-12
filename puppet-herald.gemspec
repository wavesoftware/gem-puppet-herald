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

  prydebugger = if RUBY_VERSION >= "2.0.0" then 'pry-byebug' else 'pry-debugger' end
  dependencies = {
    :runtime     => [
      'rake',
      'sinatra',
      'sinatra-contrib',
      'sinatra-activerecord',
      'micro-optparse',
      'uglifier',
      'sqlite3',
      'pg',
      'puma'
    ],
    :test        => [
      'rspec',
      'rspec-its',
      'coveralls',
      'simplecov'
    ],
    :developmant => [
      'inch',
      'travis',
      'travis-lint',
      prydebugger
    ]
  }

  dependencies[:runtime].each do |spec|
    gem.add_runtime_dependency spec
  end
  dependencies[:test].each do |spec|
    gem.add_development_dependency spec
  end
  dependencies[:developmant].each do |spec|
    gem.add_development_dependency spec
  end
  
end

# vim:ft=ruby