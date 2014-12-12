module PuppetHerald
  
  def self.version_prep desired
    version = desired
    if desired.match(/[^0-9\.]+/)
      version += "." + `git describe --tags --dirty --always`
    end
    return version.strip
  end

  VERSION     = version_prep('0.1.0.pre')
  LICENSE     = 'Apache 2.0'
  NAME        = 'Puppet Herald'
  PACKAGE     = 'puppet-herald'
  SUMMARY     = 'a Puppet report processor'
  DESCRIPTION = "Provides a gateway for consuming puppet reports, a REST API and a simple Web app to display reports."
  HOMEPAGE    = 'https://github.com/wavesoftware/puppet-herald'

end