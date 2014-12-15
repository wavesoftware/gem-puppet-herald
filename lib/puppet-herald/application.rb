require 'sinatra/base'

require 'puppet-herald/app/configuration'
require 'puppet-herald/app/api'
require 'puppet-herald/app/frontend'

module PuppetHerald
  class Application < Sinatra::Application
    use PuppetHerald::App::Configuration
    use PuppetHerald::App::Frontend
    use PuppetHerald::App::Api
    
    def self.run! options = {}, &block
      PuppetHerald::App::Configuration.dbmigrate!
      super options, *block
    end

  end
end