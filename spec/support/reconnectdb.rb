def reconnectdb
  require 'puppet-herald'
  require 'active_record'
  require 'stringio'        # silence the output
  $stdout = StringIO.new    # from migrator

  PuppetHerald::database.dbconn = 'sqlite3://:memory:'
  ActiveRecord::Base.establish_connection(PuppetHerald::database.spec)
  ActiveRecord::Base.logger.level = 2 unless ActiveRecord::Base.logger.nil?
  ActiveRecord::Migrator.up "db/migrate"

  $stdout = STDOUT
end