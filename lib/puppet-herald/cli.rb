require 'micro-optparse'
require 'logger'
require 'puppet-herald'
require 'puppet-herald/version'
require 'puppet-herald/database'

module PuppetHerald
  class CLI

    @@logger = Logger.new STDOUT
    @@errlogger = Logger.new STDERR
    @@retcode = 0

    def self.retcode= val
      @@retcode = val if @@retcode == 0
    end

    def self.logger
      @@logger
    end

    def self.errlogger
      @@errlogger
    end

    def self.run! argv=ARGV
      @@retcode = 0
      begin
        options = parse_options argv
        require 'puppet-herald/app'
        PuppetHerald::App.run! options
      rescue Exception => ex
        bug = PuppetHerald.bug(ex)
        errlogger.fatal "Unexpected error occured, mayby a bug?\n\n#{bug[:message]}\n\n#{bug[:help]}"
        self.retcode = 1
      end
      Kernel::exit @@retcode
    end

    def self.parse_options argv
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
      options = parser.process!(argv)

      logger.info "Starting #{PuppetHerald::NAME} v#{PuppetHerald::VERSION} in #{PuppetHerald::environment}..."
      PuppetHerald::Database.dbconn   = options[:dbconn]
      PuppetHerald::Database.passfile = options[:passfile]
      begin
        PuppetHerald::Database.spec :echo => true
      rescue Exception => ex
        errlogger.fatal "Database configuration is invalid!\n\n#{ex.message}"
        self.retcode = 2
        raise ex
      end

      return options
    end
  end
end