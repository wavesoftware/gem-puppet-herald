require 'fileutils'

module PuppetHerald
  class Database

    @@dbconn   = nil
    @@passfile = nil

    def self.dbconn= dbconn
      @@dbconn = dbconn
    end

    def self.passfile= passfile
      @@passfile = passfile
    end

    def self.validate! echo=false
      db = URI.parse(@@dbconn)
      connection = {}
      if db.scheme.to_s.empty?
        raise "Database scheme couldn't be empty! Connection string given: #{@@dbconn}"
      end
      if ['sqlite', 'sqlite3'].include? db.scheme
        file = File.expand_path("#{db.host}#{db.path}")
        FileUtils.touch file
        connection[:adapter]  = 'sqlite3'
        connection[:database] = file
      else
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
        puts "Using #{copy.inspect} for database."
      end
      return connection
    end

    def self.setup app
      ActiveRecord::Base.establish_connection(validate!)
    end
  end
end