ENV['RACK_ENV'] = 'test'

require 'model_helper'
require 'rspec'
require 'rack/test'

xdescribe 'The Herald App', :rollback => true do
  include Rack::Test::Methods

  def app
    require 'puppet-herald/app'
    PuppetHerald::App
  end

  it "on '/' redirects to '/app.html'" do
    get '/'
    expect(last_response).not_to be_ok
    expect(last_response.status).to eq(301)
    expect(last_response.header['Location']).to eq('http://example.org/app.html')
  end
end