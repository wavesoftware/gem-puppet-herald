def reconnectdb
  require 'puppet-herald/database'
  require 'active_record'
  require 'stringio'        # silence the output
  $stdout = StringIO.new    # from migrator

  PuppetHerald::Database.dbconn = 'sqlite3://:memory:'
  ActiveRecord::Base.establish_connection(PuppetHerald::Database.spec)
  ActiveRecord::Base.logger.level = 2 unless ActiveRecord::Base.logger.nil?
  ActiveRecord::Migrator.up "db/migrate"

  $stdout = STDOUT
end