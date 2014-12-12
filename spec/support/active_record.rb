require 'active_record'
require 'stringio'        # silence the output
$stdout = StringIO.new    # from migrator

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
ActiveRecord::Migrator.up "db/migrate"

$stdout = STDOUT

RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end