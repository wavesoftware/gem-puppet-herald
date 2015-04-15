require 'sinatra/base'
require 'sinatra/namespace'
require 'puppet-herald'
require 'puppet-herald/app/configuration'
require 'puppet-herald/models'
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
      #
      # @param request [Sinatra::Request] an request object
      # @return [Array] an response array: [code, body] or [code, headers, body]
      def post_reports(request)
        yaml = request.body.read
        report = PuppetHerald::Models::Report.create_from_yaml yaml
        body = { id: report.id }.to_json
        [201, body]
      end
      # Get a report by its ID
      #
      # @param params [Hash] an requests parsed params
      # @return [Array] an response array: [code, body] or [code, headers, body]
      def get_report(params)
        id = params[:id]
        report = PuppetHerald::Models::Report.with_log_entries(id)
        status = 200
        status = 404 if report.nil?
        body = report.to_json(include: :log_entries)
        [status, body]
      end
      # Gets all nodes with pagination
      #
      # @param request [Sinatra::Request] an request object
      # @return [Array] an response array: [code, body] or [code, headers, body]
      def nodes(request)
        pag = paginate request
        nodes = PuppetHerald::Models::Node.paginate(pag)
        [200, headers(pag), nodes.to_json(methods: :no_of_reports)]
      rescue ArgumentError => ex
        clienterror ex
      end
      # Gets a node by its ID, with pagination
      #
      # @param params [Hash] an requests parsed params
      # @param request [Sinatra::Request] an request object
      # @return [Array] an response array: [code, body] or [code, headers, body]
      def get_node(params, request)
        id = params[:id]
        pag = paginate request
        node = PuppetHerald::Models::Node.with_reports(id, pag)
        status = 200
        status = 404 if node.nil?
        body = node.to_json(include: :reports, methods: :no_of_reports)
        [status, headers(pag), body]
      rescue ArgumentError => ex
        clienterror ex
      end
      # Get a app's artifact information
      #
      # @return [Array] an response array: [code, body] or [code, headers, body]
      def version_json
        ver = {}
        [:VERSION, :LICENSE, :NAME, :PACKAGE, :SUMMARY, :DESCRIPTION, :HOMEPAGE].each do |const|
          ver[const.downcase] = PuppetHerald.const_get const
        end
        [200, ver.to_json]
      end

      private

      # Creates headers for given pagination
      #
      # @param pagination [PuppetHerald::Models::Pagination] a pagination
      # @param httpize [Boolean] if true given, will change headers to Rack format +HTTP_*+
      # @return [Hash] a HTTP request headers
      def headers(pagination, httpize = false)
        keys = httpize_keys(httpize)
        head = {
          keys[:page]  => pagination.page.to_s,
          keys[:limit] => pagination.limit.to_s
        }
        head[keys[:total]] = pagination.total.to_s unless pagination.total.nil?
        head[keys[:pages]] = pagination.pages.to_s unless pagination.pages.nil?
        head
      end

      def httpize_keys(httpize = false)
        map = PuppetHerald::Models::Pagination::KEYS.map do |k, str|
          [k, httpize_key(str, httpize)]
        end
        Hash[map]
      end

      def httpize_key(key, httpize = false)
        noop = ->(name) { name }
        oper = httpize ? method(:httpize) : noop
        oper.call key
      end

      # Creates a pagination from request
      #
      # @param request [Sinatra::Request] a HTTP request
      # @return [PuppetHerald::Models::Pagination] a pagination
      def paginate(request)
        pkey = httpize(PuppetHerald::Models::Pagination::KEYS[:page])
        lkey = httpize(PuppetHerald::Models::Pagination::KEYS[:limit])
        page = request.env[pkey] ? request.env[pkey] : PuppetHerald::Models::Pagination::DEFAULT.page
        limit = request.env[lkey] ? request.env[lkey] : PuppetHerald::Models::Pagination::DEFAULT.limit
        PuppetHerald::Models::Pagination.new(page, limit)
      end

      def httpize(header_name)
        upper = header_name.upcase.gsub('-', '_')
        "HTTP_#{upper}"
      end

      def clienterror(ex)
        err = { error: "#{ex.class}: #{ex.message}" }
        [400, err.to_json]
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
            api.nodes request
          end

          get '/nodes/:id' do
            content_type 'application/json'
            api.get_node params, request
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
