require 'spec_helper'
require 'webmock/rspec'
require 'puppet-herald/client'

describe PuppetHerald::Client, '.process' do
  let(:payload) { { :zz => 65, :yh => 12 } }
  let(:expected) { payload.to_yaml }
  before :each do
    stub_request(:post, "#{address}/api/v1/reports").with(:body => expected).
      to_return(:body => "{id: 1}", :status => 201)
  end
  subject { client.process payload }
  context 'on defaults' do
    let(:address) { 'localhost:11303' }
    let(:client) { PuppetHerald::Client.new }
    it { expect(subject).to be_truthy }
  end
  context 'on other host:port' do
    let(:address) { 'master.secure.vm:8082' }
    let(:client) { PuppetHerald::Client.new('master.secure.vm', 8082) }
    it { expect(subject).to be_truthy }
  end
end