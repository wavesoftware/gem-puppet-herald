require 'sinatra/activerecord'
require 'rspec-activerecord'

RSpec.configure do |c|
  c.fixture_path = File.expand_path("../../integration/fixtures", __FILE__)
  c.use_transactional_fixtures = true
end

def fixtures(symbol)
  ActiveRecord::FixtureSet.create_fixtures(RSpec.configuration.fixture_path, symbol.to_s)
end

def fixture(type, name)
  fixture_set = ActiveRecord::FixtureSet.all_loaded_fixtures[type.to_s]
  fixture_set.fixtures.find { |k, v| k == name.to_s }.second
end
