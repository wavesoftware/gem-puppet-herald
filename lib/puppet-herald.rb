begin
  require 'pry'
rescue LoadError
  # Do nothing here
end

# A module for Herald
module PuppetHerald
  @@root = File.dirname(File.dirname(File.realpath(__FILE__)))

  # Calculates a replative directory inside the project
  #
  # @param dir [String] a sub directory
  # @return [String] a full path to replative dir
  def self.relative_dir(dir)
    File.realpath(File.join @@root, dir)
  end

  # Gets the environment set for Herald
  # @return [Symbol] an environment
  def self.environment
    env = :production
    unless ENV['PUPPET_HERALD_ENV'].nil?
      env = ENV['PUPPET_HERALD_ENV'].to_sym
    end
    env
  end

  # Checks is running in DEVELOPMENT kind of environment (dev, ci, test)
  #
  # @return [Boolean] true if runs in development
  def self.in_dev?
    [:development, :dev, :test, :ci].include? environment
  end

  # Checks is running in production environment
  #
  # @return [Boolean] true if runs in production
  def self.in_prod?
    !in_dev?
  end

  # Reports a bug in desired format
  #
  # @param ex [Exception] an exception that was thrown
  # @return [Hash] a hash with info about bug to be displayed to user
  def self.bug(ex)
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
