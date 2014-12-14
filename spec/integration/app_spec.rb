ENV['RACK_ENV'] = 'test'

require 'support/reconnectdb'
require 'spec_helper'
require 'rspec'
require 'rack/test'

shared_examples 'a redirect to app.html' do
  it { expect(subject).not_to be_ok }
  it { expect(subject.status).to eq(301) }
  it { expect(subject.header['Location']).to eq('http://example.org/app.html') }
end

shared_examples 'a proper 200 - success' do
  it { expect(subject).to be_ok }
  it { expect(subject.status).to eq 200 }
  it { expect(subject.body).not_to be_empty }
end

shared_examples "working API" do
  it { expect(subject.content_type).to eq 'application/json' }
  it_behaves_like 'a proper 200 - success'
end

describe 'The Herald App' do
  include Rack::Test::Methods

  before(:all) { reconnectdb }

  def app
    require 'puppet-herald/app'
    PuppetHerald::App
  end

  describe "on '/' redirects to '/app.html'" do
    it_behaves_like 'a redirect to app.html' do
      subject { get '/' }
    end
  end

  describe "on '/index.html' redirects to '/app.html'" do
    it_behaves_like 'a redirect to app.html' do
      subject { get '/index.html' }
    end
  end

  describe "on main page '/app.html'" do
    subject { get '/app.html' }
    context 'in production' do
      before { expect(PuppetHerald).to receive(:is_in_prod?).and_return true }
      it { expect(subject.body).to include 'app.min.js' }
    end
    context 'in dev' do
      before { expect(PuppetHerald).to receive(:is_in_prod?).and_return false }
      it { expect(subject.body).not_to include 'app.min.js' }
      it { expect(subject.body).to include 'report.js' }
      it { expect(subject.body).to include 'nodes.js' }
      it { expect(subject.body).to include 'node.js' }
      it { expect(subject.body).to include 'artifact.js' }
    end
    it_behaves_like 'a proper 200 - success'
  end

  describe "on '/version.json'" do
    subject { get '/version.json' }
    it_behaves_like 'a proper 200 - success'
    it { expect(subject.content_type).to eq 'application/json' }
    it { expect(subject.body).to include PuppetHerald::VERSION }
  end

  describe "on '/app.min.js'" do
    subject { get '/app.min.js' }
    it_behaves_like 'a proper 200 - success'
    it { expect(subject.content_type).to eq 'application/javascript;charset=utf-8' }
  end

  describe "on '/app.min.js.map'" do
    subject { get '/app.min.js.map' }
    it_behaves_like 'a proper 200 - success'
    it { expect(subject.content_type).to eq 'application/javascript;charset=utf-8' }
  end

  describe "forcing to raise a fatal error" do
    after :each do
      Dir.glob(Dir.tmpdir + '/puppet-herald-bug*.log') { |file| Pathname.new(file).unlink }
    end
    context 'while inside json API' do
      subject { get '/-----------------force-err/application/json' }
      context 'in production' do
        before { expect(PuppetHerald).to receive(:is_in_dev?).and_return false }
        it_behaves_like 'a proper 200 - success'
        it { expect(subject.content_type).to eq 'application/json' }
      end
      context 'in dev' do
        before { expect(PuppetHerald).to receive(:is_in_dev?).and_return true }
        it { expect(subject).not_to be_ok }
        it { expect(subject.status).to eq 500 }
        it { expect(subject.content_type).to eq 'application/json' }
        it { expect(subject.body).not_to be_empty }
      end
    end
    context 'while in standard WWW' do
      subject { get '/-----------------force-err/html/text' }
      context 'in production' do
        before { expect(PuppetHerald).to receive(:is_in_dev?).and_return false }
        it_behaves_like 'a proper 200 - success'
        it { expect(subject.content_type).to eq 'application/json' }
      end

      context 'in dev' do
        before { expect(PuppetHerald).to receive(:is_in_dev?).and_return true }
        it { expect(subject).not_to be_ok }
        it { expect(subject.content_type).to eq 'html/text' }
        it { expect(subject.status).to eq 500 }
        it { expect(subject.body).not_to be_empty }
      end
    end
  end

  context 'API call' do

    before :each do
      reconnectdb
    end
    describe "put '/api/v1/provide-log'" do
      let(:yaml) { File.read(File.expand_path("../fixtures/changed-notify.yaml", __FILE__)) }
      subject { put '/api/v1/provide-log', yaml }
      it_behaves_like 'working API'
    end
    describe "get '/api/v1/nodes'" do
      subject { get '/api/v1/nodes' }
      it_behaves_like 'working API'
    end
    describe "get '/api/v1/node/1'" do
      subject { get '/api/v1/node/1' }
      it_behaves_like 'working API'
    end
    describe "get '/api/v1/report/1'" do
      subject { get '/api/v1/report/1' }
      it_behaves_like 'working API'
    end
  end
  
end