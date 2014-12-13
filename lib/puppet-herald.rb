begin
  require 'pry'
rescue LoadError
  # Do nothing here
end

module PuppetHerald

  @@root = File.dirname(File.dirname(File.realpath(__FILE__)))

  def self.relative_dir dir
    File.realpath(File.join @@root, dir)
  end

  def self.environment
    env = :production
    unless ENV['PUPPET_HERALD_ENV'].nil?
      env = ENV['PUPPET_HERALD_ENV'].to_sym
    end
    return env
  end

  def self.is_in_dev?
    return [:development, :dev, :test, :ci].include? environment
  end

  def self.is_in_prod?
    return !is_in_dev?
  end

  def self.bug ex
    file = Tempfile.new(['puppet-herald-bug', '.log'])
    filepath = file.path
    file.close
    file.unlink
    message = "v#{PuppetHerald::VERSION}-#{ex.class.to_s}: #{ex.message}"
    contents = message + "\n\n" + ex.backtrace.join("\n") + "\n"
    File.write(filepath, contents)
    bugo = {
      :message  => message,
      :homepage => PuppetHerald::HOMEPAGE,
      :bugfile  => filepath,
      :help     => "Please report this bug to #{PuppetHerald::HOMEPAGE} by passing contents of bug file: #{filepath}"
    }
    return bugo
  end
end

require 'puppet-herald/database'
