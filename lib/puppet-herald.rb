begin
  require 'pry'
rescue LoadError # rubocop:disable Lint/HandleExceptions
  # Do nothing here
end

require 'puppet-herald/database'
require 'logger'
require 'logger/colors'

# A module for Herald
module PuppetHerald
  @root = File.dirname(File.dirname(File.realpath(__FILE__)))
  @database = PuppetHerald::Database.new
  @logger = Logger.new STDOUT
  @errlogger = Logger.new STDERR

  class << self
    # Logger for CLI interface (error)
    # @return [Logger] logger for CLI
    attr_reader :errlogger

    # Logger for CLI interface
    # @return [Logger] logger for CLI
    attr_reader :logger

    # A database object
    # @return [PuppetHerald::Database] a database object
    def database  # rubocop:disable Style/TrivialAccessors
      @database
    end

    # Calculates a replative directory inside the project
    #
    # @param dir [String] a sub directory
    # @return [String] a full path to replative dir
    def relative_dir(dir)
      File.realpath(File.join @root, dir)
    end

    def environment=(newenv)
      envsymbol = newenv.to_s.to_sym
      ENV['PUPPET_HERALD_ENV'] = envsymbol.to_s
      rackenv
      setup_logger
    end

    # Setups logger's level
    #
    # @return [nil]
    def setup_logger
      logger.level = self.in_dev? ? Logger::DEBUG : Logger::INFO
      errlogger.level = logger.level
      nil
    end

    # Gets the environment set for Herald
    #
    # @return [Symbol] an environment
    def environment
      ENV['PUPPET_HERALD_ENV'] = :production.to_s if ENV['PUPPET_HERALD_ENV'].nil?
      ENV['PUPPET_HERALD_ENV'].to_sym
    end

    # Rack environment
    #
    # @return [Symbol] Rack environment
    def rackenv
      case environment
      when :dev, :development
        rackenv = :development
      when :test, :ci
        rackenv = :test
      else
        rackenv = :production
      end
      ENV['RACK_ENV'] = rackenv.to_s
      rackenv
    end

    # Checks is running in DEVELOPMENT kind of environment (dev, ci, test)
    #
    # @return [Boolean] true if runs in development
    def in_dev?
      [:development, :dev, :test, :ci].include? environment
    end

    # Checks is running in production environment
    #
    # @return [Boolean] true if runs in production
    def in_prod?
      !in_dev?
    end

    # Reports a bug in desired format
    #
    # @param ex [Exception] an exception that was thrown
    # @return [Hash] a hash with info about bug to be displayed to user
    def bug(ex)
      file = Tempfile.new(['puppet-herald-bug', '.log'])
      filepath = file.path
      file.close
      file.unlink
      message = "v#{PuppetHerald::VERSION}-#{ex.class}: #{ex.message}"
      contents = message + "\n\n" + ex.backtrace.join("\n") + "\n"
      File.write(filepath, contents)
      bugo = {
        message: message,
        homepage: PuppetHerald::HOMEPAGE,
        bugfile: filepath,
        help: "Please report this bug to #{PuppetHerald::HOMEPAGE} by passing contents of bug file: #{filepath}"
      }
      bugo
    end
  end
  PuppetHerald.rackenv
  PuppetHerald.setup_logger
end
