# A module for Herald
module PuppetHerald
  # Prepare version
  #
  # @param desired [String] a desired version
  # @return [String] a prepared version
  def self.version_prep(desired)
    version = desired
    if desired.match(/[^0-9\.]+/)
      git = `git describe --tags --dirty --always`
      version += '.' + git.gsub('-', '.')
    end
    version.strip
  end

  # Version for Herald
  VERSION     = version_prep '0.2.0.pre'
  # Lincense for Herald
  LICENSE     = 'Apache 2.0'
  # Project name
  NAME        = 'Puppet Herald'
  # Package (gem) for Herald
  PACKAGE     = 'puppet-herald'
  # A summary info
  SUMMARY     = 'a Puppet report processor'
  # A description info
  DESCRIPTION = 'Provides a gateway for consuming puppet reports, a REST API and a simple Web app to display reports.'
  # A homepage for Herald
  HOMEPAGE    = 'https://github.com/wavesoftware/gem-puppet-herald'
end
