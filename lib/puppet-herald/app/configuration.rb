require 'logger'
require 'sinatra/base'
require 'sinatra/namespace'
require 'sinatra/activerecord'
require 'puppet-herald'
require 'puppet-herald/javascript'

# A module for Herald
module PuppetHerald
  # A module that holds module of app
  module App
    # A configuration for application
    class Configuration < Sinatra::Base
      register Sinatra::ActiveRecordExtension

      set :database, PuppetHerald.database.spec unless PuppetHerald.database.spec.nil?

      class << self
        # Migrates a database to state desired for the application
        #
        # @return [nil]
        def dbmigrate!
          ActiveRecord::Base.establish_connection(PuppetHerald.database.spec)
          setup_database_logger
          ActiveRecord::Migrator.up 'db/migrate'
          ActiveRecord::Base.clear_active_connections!
          nil
        end

        # Is request part of the API
        # @param req [Sinatra::Request] a request to check
        # @return [Boolean] true, if given request point to part of the API
        def api?(req)
          (req.path.start_with?('/api') || req.path.start_with?('/version.json'))
        end

        private

        # Sets logger level for database handlers
        #
        # @return [nil]
        def setup_database_logger
          if PuppetHerald.in_dev?
            ActiveRecord::Base.logger.level = Logger::DEBUG
          else
            ActiveRecord::Base.logger.level = Logger::WARN
          end
          nil
        end
      end

      if PuppetHerald.in_dev?
        set :environment, :development
      else
        set :environment, :production
      end
      set :show_exceptions, false

      error do
        @bug = PuppetHerald.bug env['sinatra.error']
        if PuppetHerald::App::Configuration.api? request
          content_type 'application/json'
          @bug.to_json
        else
          erb :err500
        end
      end
    end
  end
end
