require 'micro-optparse'
require 'puppet-herald'
require 'puppet-herald/version'
require 'puppet-herald/database'

module PuppetHerald
  class CLI

    def self.parse_options
      usage = ""
      banner = <<-eos
#{PuppetHerald::NAME} v#{PuppetHerald::VERSION} - #{PuppetHerald::SUMMARY}

#{PuppetHerald::DESCRIPTION}

Usage: #{$0} [options]

For --dbconn option you can use both PostgreSQL and SQLite3 (postgresql://host/db, sqlite://file/path).
CAUTION! For security reasons, don't pass password in connection string, use --passfile option!

      eos
      home = File.expand_path('~')
      defaultdb     = "sqlite://#{home}/pherald.db"
      defaultdbpass = "#{home}/.pherald.pass"
      parser = Parser.new do |p|
        p.banner = banner
        p.version = PuppetHerald::VERSION
        p.option :bind, "Hostname to bind to", :default => 'localhost'
        p.option :port, "Port to use", :default => 11303, :value_satisfies => lambda {|x| x >= 100 && x <= 65000}
        p.option :dbconn, "Connection string to database, see info above", :default => defaultdb
        p.option :passfile, "If using postgresql, this file will be read for password to database", :default => defaultdbpass
      end
      options = parser.process!

      puts "Starting #{PuppetHerald::NAME} v#{PuppetHerald::VERSION}..."
      PuppetHerald::Database.dbconn   = options[:dbconn]
      PuppetHerald::Database.passfile = options[:passfile]
      begin
        PuppetHerald::Database.validate! :echo => true
      rescue Exception => ex
        STDERR.puts "FATAL ERROR - Database configuration is invalid!\n\n#{ex.message}"
        exit 2
      end
      begin
        PuppetHerald::App.run! options
      rescue Exception => ex
        bug = PuppetHerald::App.bug(ex)
        STDERR.puts "FATAL ERROR - Unexpected error occured, mayby a bug?\n\n#{bug[:message]}\n\n#{bug[:help]}"
        exit 1
      end
    end
  end
end