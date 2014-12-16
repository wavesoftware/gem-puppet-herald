require 'fileutils'
require 'logger'

module PuppetHerald
  # A class for a database configuration
  class Database
    @@dbconn   = nil
    @@passfile = nil
    @@logger = Logger.new STDOUT

    # Gets a logger for database
    # @return [Logger] a logger
    def self.logger
      @@logger
    end

    # Sets a database connection
    # @return [String] a dbconnection string
    def self.dbconn=(dbconn)
      @@dbconn = dbconn
    end

    # Sets a passfile
    # @return [String] a password file
    def self.passfile=(passfile)
      @@passfile = passfile
    end

    # Compiles a spec for database creation
    #
    # @param echo [Boolean] should echo logs on screen?
    # @return [Hash] a database configuration
    def self.spec(echo = false)
      return nil if @@dbconn.nil?
      connection = {}
      match = @@dbconn.match(/^(sqlite3?|postgres(?:ql)?):\/\/(.+)$/)
      unless match
        fail "Invalid database connection string given: #{@@dbconn}"
      end
      if %w(sqlite sqlite3).include? match[1]
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
      connection
    end
  end
end
