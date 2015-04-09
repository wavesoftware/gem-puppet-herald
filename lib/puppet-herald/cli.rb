require 'micro-optparse'
require 'puppet-herald'
require 'puppet-herald/version'
require 'puppet-herald/database'

# A module for Herald
module PuppetHerald
  # A CLI class
  class CLI
    # Initialize CLI
    # @return [CLI] an CLI object
    def initialize
      self
    end

    # Executes an Herald app from CLI
    #
    # @param argv [Array] an argv from CLI
    # @return [Integer] a status code for program
    def run!(argv = ARGV)
      PuppetHerald.environment

      options = parse_or_kill argv, 2
      run_or_kill options, 1
      Kernel.exit 0
    end

    protected

    # Parse an ARGV command line arguments
    # @param argv [Array] an argv from CLI
    # @return [Hash] options to use by application
    def parse(argv)
      options = parser.process!(argv)

      msg = "Starting #{PuppetHerald::NAME} v#{PuppetHerald::VERSION} in #{PuppetHerald.environment}..."
      PuppetHerald.logger.info msg
      PuppetHerald.database.dbconn   = options[:dbconn]
      PuppetHerald.database.passfile = options[:passfile]
      PuppetHerald.database.spec(true)
      options
    end

    private

    def run_or_kill(options, retcode)
      require 'puppet-herald/application'
      PuppetHerald::Application.run! options
    rescue StandardError => ex
      bug = PuppetHerald.bug(ex)
      PuppetHerald.errlogger.fatal "Unexpected error occured, mayby a bug?\n\n#{bug[:message]}\n\n#{bug[:help]}"
      Kernel.exit retcode
    end

    def parse_or_kill(argv, retcode)
      return parse argv
    rescue StandardError => ex
      PuppetHerald.errlogger.fatal "Database configuration is invalid!\n\n#{ex.message}"
      Kernel.exit retcode
    end

    def banner
      txt = <<-eos
#{PuppetHerald::NAME} v#{PuppetHerald::VERSION} - #{PuppetHerald::SUMMARY}

#{PuppetHerald::DESCRIPTION}

Usage: #{$PROGRAM_NAME} [options]

For --dbconn option you can use both PostgreSQL and SQLite3 (postgresql://host/db, sqlite://file/path).
CAUTION! For security reasons, don't pass password in connection string, use --passfile option!

      eos
      txt
    end

    def parser
      home = File.expand_path('~')
      defaultdb     = "sqlite://#{home}/pherald.db"
      defaultdbpass = "#{home}/.pherald.pass"
      Parser.new do |p|
        p.banner = banner
        p.version = PuppetHerald::VERSION
        p.option :bind, 'Hostname to bind to', default: 'localhost'
        p.option :port, 'Port to use', default: 11_303, value_satisfies: ->(x) { x >= 1 && x <= 65_535 }
        p.option :dbconn, 'Connection string to database, see info above', default: defaultdb
        p.option(
          :passfile,
          'If using postgresql, this file will be read for password to database',
          default: defaultdbpass
        )
      end
    end
  end
end
