begin
  require 'pry'
rescue LoadError
  # Do nothing here
end

module PuppetHerald

  @@root = File.dirname(File.dirname(File.realpath(__FILE__)))

  def self.relative_dir dir
    File.join @@root, dir
  end

  def self.port
    @@port
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
end

require 'puppet-herald/database'
require 'puppet-herald/app'
