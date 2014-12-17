require 'sinatra/base'

require 'puppet-herald/app/configuration'
require 'puppet-herald/app/api'
require 'puppet-herald/app/frontend'

# A module for Herald
module PuppetHerald
  # Class for an Herald sinatra application
  class Application < Sinatra::Application
    use PuppetHerald::App::Configuration
    use PuppetHerald::App::Frontend
    use PuppetHerald::App::Api

    class << self
      # Executes the Herald application
      #
      # @param options [Hash] an extra options for Rack server
      # @param block [block] an extra configuration block
      # @return [Sinatra::Application] an Herald application
      def run!(options = {}, &block)
        PuppetHerald::App::Configuration.dbmigrate!
        super options, *block
      end
    end
  end
end
