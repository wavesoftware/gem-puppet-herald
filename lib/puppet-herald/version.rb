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

  VERSION     = version_prep '0.2.0.pre'
  LICENSE     = 'Apache 2.0'
  NAME        = 'Puppet Herald'
  PACKAGE     = 'puppet-herald'
  SUMMARY     = 'a Puppet report processor'
  DESCRIPTION = 'Provides a gateway for consuming puppet reports, a REST API and a simple Web app to display reports.'
  HOMEPAGE    = 'https://github.com/wavesoftware/gem-puppet-herald'
end
