require 'sinatra/base'
require "sinatra/namespace"
require 'sinatra/activerecord'
require 'puppet-herald'
require 'puppet-herald/javascript'
require 'puppet-herald/models/node'
require 'puppet-herald/models/report'

module PuppetHerald
  class App < Sinatra::Base
    register Sinatra::Namespace
    register Sinatra::ActiveRecordExtension
    configure [:production, :development] do
      enable :logging
      PuppetHerald::Database.setup self
    end
    if PuppetHerald::is_in_dev?
      set :environment, :development
    else
      set :environment, :production
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

    error do
      @bug = PuppetHerald::App.bug(env['sinatra.error'])
      erb :err500
    end

    get %r{/app\.min\.(js\.map|js)} do |ext|
      content_type 'application/javascript'
      ugly = PuppetHerald::Javascript::uglify '/app.min.js.map'
      ugly[ext]
    end
    
    get '/' do
      redirect "/app.html", 301
    end

    get '/index.html' do
      redirect "/app.html", 301
    end

    get '/app.html' do
      if PuppetHerald::is_in_prod?
        @minified = '.min'
        @files = ['/app.min.js']
      else
        @minified = ''
        @files = PuppetHerald::Javascript::files
      end
      erb :app
    end

    get '/version.json' do
      content_type 'application/json'
      ver = {}
      [:VERSION, :LICENSE, :NAME, :PACKAGE, :SUMMARY, :DESCRIPTION, :HOMEPAGE].each do |const|
        ver[const.downcase] = PuppetHerald::const_get const
      end
      ver.to_json
    end

    namespace '/api' do
      namespace '/v1' do

        put '/provide-log' do
          content_type 'application/json'
          yaml = request.body.read
          report = Report.create_from_yaml yaml

          {:status => :ok}.to_json
        end

        get '/nodes' do
          content_type 'application/json'
          nodes = Node.all
          nodes.to_json
        end

        get '/node/:id' do
          content_type 'application/json'
          id = params[:id]
          Node.get_with_reports(id).
            to_json(:include => :reports)
        end

        get '/report/:id' do
          content_type 'application/json'
          id = params[:id]
          Report.get_with_log_entries(id).
            to_json(:include => :log_entries)
        end
      end
    end
  end
end