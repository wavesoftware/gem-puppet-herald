# -*- encoding: utf-8 -*-

ROOT = Pathname.new(File.expand_path('../', __FILE__))
LIB = Pathname.new('lib/puppet-herald')
ph = ROOT.join(LIB)
require ph.join('version')

Gem::Specification.new do |gem|
  deps = Dir.glob(LIB.join('public').join('bower_components').join('**/*'))
  gem.name          = PuppetHerald::PACKAGE
  gem.version       = PuppetHerald::VERSION
  gem.author        = 'Krzysztof Suszynski'
  gem.email         = 'krzysztof.suszynski@wavesoftware.pl'
  gem.license       = PuppetHerald::LICENSE
  gem.homepage      = PuppetHerald::HOMEPAGE
  gem.summary       = PuppetHerald::SUMMARY
  gem.description   = PuppetHerald::DESCRIPTION

  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n").concat(deps)
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ['lib']

  # Dependencies
  gem.required_ruby_version = '>= 1.9.2'

  # Runtime
  gem.add_runtime_dependency 'sinatra',              '~> 1.4.0'
  gem.add_runtime_dependency 'sinatra-contrib',      '~> 1.4.0'
  gem.add_runtime_dependency 'sinatra-activerecord', '~> 2.0.0'
  gem.add_runtime_dependency 'rufus-scheduler',      '~> 3.2.0'
  gem.add_runtime_dependency 'micro-optparse',       '~> 1.2.0'
  gem.add_runtime_dependency 'uglifier',             '~> 2.7.0'
  gem.add_runtime_dependency 'logger-colors',        '~> 1.0.0'
end

# vim:ft=ruby
