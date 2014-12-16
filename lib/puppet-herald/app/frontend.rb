require 'puppet-herald'
require 'puppet-herald/javascript'
require 'sinatra/base'
require 'sinatra/namespace'

module PuppetHerald::App

  class Frontend < Sinatra::Base
    use PuppetHerald::App::Configuration

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

  end

end