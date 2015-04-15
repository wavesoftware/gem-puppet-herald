require 'fileutils'

# A module for Herald
module PuppetHerald
  # A class for a database configuration
  class Database
    def initialize
      @dbconn   = nil
      @passfile = nil
    end

    # Sets a database connection
    # @return [String] a dbconnection string
    attr_writer :dbconn

    # Sets a passfile
    # @return [String] a password file
    attr_writer :passfile

    # Compiles a spec for database creation
    #
    # @param log [Boolean] should log on screen?
    # @return [Hash] a database configuration
    def spec(log = false)
      connection = process_spec
      print_config(connection, log)
      connection
    end

    private

    def process_spec
      match = validate_conn(@dbconn)
      if %w(sqlite sqlite3).include? match[1]
        connection = sqlite(match)
      else
        connection = postgresql(@dbconn, @passfile)
      end
      connection
    end

    def validate_conn(dbconn)
      fail 'Connection is not set, can not validate database connection' if dbconn.nil?
      match = dbconn.match(%r{^(sqlite3?|postgres(?:ql)?)://(.+)$})

      fail "Invalid database connection string given: #{dbconn}" if match.nil?
      match
    end

    def print_config(connection, log)
      return unless log
      copy = connection.dup
      copy[:password] = '***' unless copy[:password].nil?
      PuppetHerald.logger.info "Using #{copy.inspect} for database."
    end

    def sqlite(match)
      connection = {}
      dbname = match[2]
      unless dbname.match(/^(?:file:)?:mem/)
        dbname = File.expand_path(dbname)
        FileUtils.touch dbname
      end
      connection[:adapter]  = 'sqlite3'
      connection[:database] = dbname
      connection
    end

    def postgresql(conn, passfile)
      connection = {}
      db = URI.parse conn
      dbname = db.path[1..-1]
      connection[:adapter]  = pgscheme(db.scheme)
      connection[:host]     = db.host
      connection[:username] = pguser(db.user, dbname)
      connection[:password] = File.read(passfile).strip
      connection[:database] = dbname
      connection[:encoding] = 'utf8'
      pgport(connection, db.port)
      connection
    end

    def pgport(connection, port)
      connection[:port] = port unless port.nil?
    end

    def pgscheme(scheme)
      scheme == 'postgres' ? 'postgresql' : scheme
    end

    def pguser(user, dbname)
      user.nil? ? dbname : user
    end
  end
end
