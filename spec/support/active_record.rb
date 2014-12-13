require 'puppet-herald/database'
require 'active_record'
require 'stringio'        # silence the output
$stdout = StringIO.new    # from migrator

PuppetHerald::Database.dbconn = 'sqlite3://:memory:'
ActiveRecord::Base.establish_connection(PuppetHerald::Database.spec)
ActiveRecord::Migrator.up "db/migrate"

$stdout = STDOUT

RSpec.configure do |config|
  config.around(:example, {:rollback => true}) do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end