# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
directories %w(lib test spec bin)

## Uncomment to clear the screen before every task
clearing :on

ignore /coverage/, /bower_components/

guard :rspec, cmd: "bundle exec rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # Feel free to open issues for suggestions and improvements

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  # Turnip features and steps
  watch(%r{^spec/acceptance/(.+)\.feature$})
  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$}) do |m|
    Dir[File.join("**/#{m[1]}.feature")][0] || "spec/acceptance"
  end
end

guard :bundler do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  watch(/^.+\.gemspec/)
end

guard :rake, :task => 'inch', :all_on_start => false do
  watch(%r{^lib/(.+).rb$})
end

guard :rake, :task => 'js:test', :all_on_start => false do
  watch(%r{^lib/puppet-herald/public/(.+).js$})
  watch(%r{^test/javascript/src/(.+)_test.js$})
  watch(%r{^test/javascript/karma.conf.js$})
  watch(%r{^test/javascript/bower.json$})
  watch(%r{^package.json$})
end

guard :rubocop do
  watch(%{^Rakefile$})
  watch(%r{.+\.rb$})
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end
