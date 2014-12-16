require 'logger'
require 'sinatra/base'
require 'sinatra/namespace'
require 'sinatra/activerecord'
require 'puppet-herald'
require 'puppet-herald/javascript'

module PuppetHerald::App
  class Configuration < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    set :database, PuppetHerald::Database.spec unless PuppetHerald::Database.spec.nil?

    # Migrates a database to state desired for the application
    #
    # @return [nil]
    def self.dbmigrate!
      ActiveRecord::Base.establish_connection(PuppetHerald::Database.spec)
      set_dblog!
      ActiveRecord::Migrator.up 'db/migrate'
      ActiveRecord::Base.clear_active_connections!
      nil
    end

    # Sets logger level for database handlers
    #
    # @return [nil]
    def self.set_dblog!
      if PuppetHerald.in_dev?
        ActiveRecord::Base.logger.level = Logger::DEBUG
      else
        ActiveRecord::Base.logger.level = Logger::WARN
      end
      nil
    end

    def self.is_api?(req)
      (req.path.start_with?('/api') || req.path.start_with?('/version.json'))
    end

    if PuppetHerald.in_dev?
      set :environment, :development
    else
      set :environment, :production
    end

    error do
      @bug = PuppetHerald.bug env['sinatra.error']
      if PuppetHerald::App::Configuration.is_api? request
        content_type 'application/json'
        @bug.to_json
      else
        erb :err500
      end
    end

    get %r{/app\.min\.(js\.map|js)} do |ext|
      content_type 'application/javascript'
      ugly = PuppetHerald::Javascript.uglify '/app.min.js.map'
      ugly[ext]
    end
  end
end
