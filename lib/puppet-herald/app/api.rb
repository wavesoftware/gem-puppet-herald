require 'sinatra/base'
require 'sinatra/namespace'
require 'puppet-herald'
require 'puppet-herald/app/configuration'
require 'puppet-herald/models/node'
require 'puppet-herald/models/report'

# A module for Herald
module PuppetHerald
  # Module that holds modules of Sinatra app
  module App
    # An implementation of API v1
    class ApiImplV1
      # Constructor
      # @param app [Sinatra::Base] an app module
      # @return [ApiImplV1] an API impl
      def initialize(app)
        @app = app
      end
      # Creates a new report
      # @param request [Sinatra::Request] an request object
      # @return [Array] an response array: [code, body] or [code, headers, body]
      def post_reports(request)
        yaml = request.body.read
        report = PuppetHerald::Models::Report.create_from_yaml yaml
        body = { id: report.id }.to_json
        [201, body]
      end
      # Get a report by its ID
      # @param params [Hash] an requests parsed params
      # @return [Array] an response array: [code, body] or [code, headers, body]
      def get_report(params)
        id = params[:id]
        report = PuppetHerald::Models::Report.get_with_log_entries(id)
        status = 200
        status = 404 if report.nil?
        body = report.to_json(include: :log_entries)
        [status, body]
      end
      # Gets all nodes
      # @return [Array] an response array: [code, body] or [code, headers, body]
      def nodes
        nodes = PuppetHerald::Models::Node.all
        [200, nodes.to_json]
      end
      # Gets a node by its ID
      # @param params [Hash] an requests parsed params
      # @return [Array] an response array: [code, body] or [code, headers, body]
      def get_node(params)
        id = params[:id]
        node = PuppetHerald::Models::Node.get_with_reports(id)
        status = 200
        status = 404 if node.nil?
        body = node.to_json(include: :reports)
        [status, body]
      end
      # Get a app's artifact information
      # @return [Array] an response array: [code, body] or [code, headers, body]
      def version_json
        ver = {}
        [:VERSION, :LICENSE, :NAME, :PACKAGE, :SUMMARY, :DESCRIPTION, :HOMEPAGE].each do |const|
          ver[const.downcase] = PuppetHerald.const_get const
        end
        [200, ver.to_json]
      end
    end

    # An API app module
    class Api < Sinatra::Base
      register Sinatra::Namespace
      use PuppetHerald::App::Configuration
      set :api, ApiImplV1.new(self)
      helpers do
        # API getter
        # @return [ApiImplV1] an api object
        def api
          settings.api
        end
      end

      get '/version.json' do
        content_type 'application/json'
        api.version_json
      end

      namespace '/api' do
        namespace '/v1' do
          post '/reports' do
            content_type 'application/json'
            api.post_reports request
          end

          get '/nodes' do
            content_type 'application/json'
            api.nodes
          end

          get '/nodes/:id' do
            content_type 'application/json'
            api.get_node params
          end

          get '/reports/:id' do
            content_type 'application/json'
            api.get_report params
          end
        end
      end
    end
  end
end
