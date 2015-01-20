# -*- encoding: utf-8 -*-

require File.expand_path('../lib/puppet-herald/version', __FILE__)
require File.expand_path('../lib/puppet-herald/javascript', __FILE__)

Gem::Specification.new do |gem|
  js = PuppetHerald::Javascript.new

  gem.name          = PuppetHerald::PACKAGE
  gem.version       = PuppetHerald::VERSION
  gem.author        = 'Krzysztof Suszynski'
  gem.email         = 'krzysztof.suszynski@wavesoftware.pl'
  gem.license       = PuppetHerald::LICENSE
  gem.homepage      = PuppetHerald::HOMEPAGE
  gem.summary       = PuppetHerald::SUMMARY
  gem.description   = PuppetHerald::DESCRIPTION

  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n").concat(js.deps)
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n").concat(js.dev_deps)
  gem.require_paths = ['lib']

  # Dependencies
  gem.required_ruby_version = '>= 1.9.2'

  # Runtime
  gem.add_runtime_dependency 'sinatra',              '~> 1.4'
  gem.add_runtime_dependency 'sinatra-contrib',      '~> 1.4'
  gem.add_runtime_dependency 'sinatra-activerecord', '~> 2.0'
  gem.add_runtime_dependency 'micro-optparse',       '~> 1.2'
  gem.add_runtime_dependency 'uglifier',             '~> 2.6'
end

# vim:ft=ruby
