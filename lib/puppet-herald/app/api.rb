require 'sinatra/base'
require 'sinatra/namespace'
require 'puppet-herald'
require 'puppet-herald/app/configuration'
require 'puppet-herald/models/node'
require 'puppet-herald/models/report'

module PuppetHerald::App
  class Api < Sinatra::Base
    register Sinatra::Namespace
    use PuppetHerald::App::Configuration

    get %r{/-----------------force-err/(.*)} do |type|
      if PuppetHerald.is_in_dev?
        content_type type
        fail 'an expected error'
      end
      content_type 'application/json'
      { status: :ok }.to_json
    end

    get '/version.json' do
      content_type 'application/json'
      ver = {}
      [:VERSION, :LICENSE, :NAME, :PACKAGE, :SUMMARY, :DESCRIPTION, :HOMEPAGE].each do |const|
        ver[const.downcase] = PuppetHerald.const_get const
      end
      ver.to_json
    end

    namespace '/api' do
      namespace '/v1' do
        put '/provide-log' do
          content_type 'application/json'
          yaml = request.body.read
          report = PuppetHerald::Models::Report.create_from_yaml yaml

          { status: :ok }.to_json
        end

        get '/nodes' do
          content_type 'application/json'
          nodes = PuppetHerald::Models::Node.all
          nodes.to_json
        end

        get '/node/:id' do
          content_type 'application/json'
          id = params[:id]
          PuppetHerald::Models::Node.get_with_reports(id)
            .to_json(include: :reports)
        end

        get '/report/:id' do
          content_type 'application/json'
          id = params[:id]
          PuppetHerald::Models::Report.get_with_log_entries(id)
            .to_json(include: :log_entries)
        end
      end
    end
  end
end
