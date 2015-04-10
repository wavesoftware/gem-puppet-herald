require 'puppet-herald'
require 'puppet-herald/javascript'
require 'sinatra/base'
require 'sinatra/namespace'

# A module for Herald
module PuppetHerald
  # A module that holds module of app
  module App
    # Frontend logic impl internal class
    class LogicImpl
      def initialize
        @js = PuppetHerald::Javascript.new
      end
      # Gets an app.html
      # @dodgy executed also to raise an exception for testing (application_spec)
      def app_html
        if PuppetHerald.in_prod?
          minified = '.min'
          files = ['/app.min.js']
        else
          minified = ''
          files = @js.files
        end
        [minified, files]
      end
      # Uglify an application JS's into one minified JS file
      # @param mapname [String] name of source map to be put into uglified JS
      # @return [Hash] a hash with uglified JS and source map
      def uglify(mapname)
        @js.uglify mapname
      end
    end
    # Class that holds implementation of frontent interface
    class Frontend < Sinatra::Base
      use PuppetHerald::App::Configuration
      set :logic, PuppetHerald::App::LogicImpl.new

      get '/' do
        redirect '/app.html', 301
      end

      get '/index.html' do
        redirect '/app.html', 301
      end

      get '/app.html' do
        cache_control :public, :must_revalidate, max_age: 60 if PuppetHerald.in_prod?
        @minified, @files, @deps = settings.logic.app_html
        erb :app
      end

      get %r{^/app\.min\.(js\.map|js)$} do |ext|
        content_type 'application/javascript'
        contents = settings.logic.uglify('/app.min.js.map')[ext]
        cache_control :public, :must_revalidate, max_age: 60 if PuppetHerald.in_prod?
        contents
      end
    end
  end
end
