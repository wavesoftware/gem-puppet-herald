require 'logger'
require 'sinatra/base'
require 'sinatra/namespace'
require 'sinatra/activerecord'
require 'puppet-herald'
require 'puppet-herald/javascript'
require 'puppet-herald/purgecronjob'

# A module for Herald
module PuppetHerald
  # A module that holds module of app
  module App
    # A configuration for application
    class Configuration < Sinatra::Base
      register Sinatra::ActiveRecordExtension

      set :database, PuppetHerald.database.spec unless PuppetHerald.database.spec.nil?

      class << self
        # Configure the application
        #
        # @param options [Hash] optional parameters
        # @return [nil]
        def configure_app(options = {})
          cron = options.fetch(:cron, true)
          dbmigrate = options.fetch(:dbmigrate, true)
          setup_database_logger
          dbmigrate! if dbmigrate
          enable_cron if cron
          nil
        end

        # De-configure the application
        #
        # @param options [Hash] optional parameters
        # @return [nil]
        def deconfigure_app(options = {})
          cron = options.fetch(:cron, true)
          disable_cron if cron
          nil
        end

        # Is request part of the API
        # @param req [Sinatra::Request] a request to check
        # @return [Boolean] true, if given request point to part of the API
        def api?(req)
          (req.path.start_with?('/api') || req.path.start_with?('/version.json'))
        end

        private

        # Migrates a database to state desired for the application
        #
        # @return [nil]
        def dbmigrate!
          ActiveRecord::Base.establish_connection(PuppetHerald.database.spec)
          ActiveRecord::Migrator.up 'db/migrate'
          ActiveRecord::Base.clear_active_connections!
          nil
        end

        # Enable cron in application
        def enable_cron
          require 'rufus/scheduler'
          set :scheduler, Rufus::Scheduler.new
          job = PuppetHerald::PurgeCronJob.new
          # Run every 30 minutes, by default
          cron = ENV['PUPPET_HERALD_PURGE_CRON'] || '*/30 * * * *'
          PuppetHerald.logger.info "Stating scheduler with: `#{cron}`..."
          scheduler.cron(cron) { job.run! }
        end

        # Disable cron in application
        def disable_cron
          scheduler.shutdown if scheduler.up?
          PuppetHerald.logger.info 'Scheduler stopped.'
        end

        # Sets logger level for database handlers
        #
        # @return [nil]
        def setup_database_logger
          ActiveRecord::Base.logger = PuppetHerald.logger
          nil
        end
      end

      set :environment, PuppetHerald.rackenv
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
