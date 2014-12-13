require 'fileutils'
require 'logger'

module PuppetHerald
  class Database

    @@dbconn   = nil
    @@passfile = nil
    @@logger = Logger.new STDOUT

    def self.logger
      @@logger
    end

    def self.dbconn= dbconn
      @@dbconn = dbconn
    end

    def self.passfile= passfile
      @@passfile = passfile
    end

    def self.spec echo=false
      return nil if @@dbconn.nil?
      connection = {}
      match = @@dbconn.match(/^(sqlite3?|postgres(?:ql)?):\/\/(.+)$/)
      unless match
        raise "Invalid database connection string given: #{@@dbconn}"
      end
      if ['sqlite', 'sqlite3'].include? match[1]
        dbname = match[2]
        unless dbname.match /^(?:file:)?:mem/
          dbname = File.expand_path(dbname)
          FileUtils.touch dbname
        end
        connection[:adapter]  = 'sqlite3'
        connection[:database] = dbname
      else
        db = URI.parse @@dbconn
        dbname = db.path[1..-1]
        connection[:adapter]  = db.scheme == 'postgres' ? 'postgresql' : db.scheme
        connection[:host]     = db.host
        connection[:port]     = db.port unless db.port.nil?
        connection[:username] = db.user.nil? ? dbname : db.user
        connection[:password] = File.read(@@passfile).strip
        connection[:database] = dbname
        connection[:encoding] = 'utf8'
      end
      if echo
        copy = connection.dup
        copy[:password] = '***' unless copy[:password].nil?
        logger.info "Using #{copy.inspect} for database."
      end
      return connection
    end
  end
end