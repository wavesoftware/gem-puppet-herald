require 'model_helper'
require 'puppet-herald/app/configuration'

describe PuppetHerald::App::Configuration do
  after(:all) do
    PuppetHerald.environment = :test
  end
  describe '.setup_database_logger' do
    subject { PuppetHerald::App::Configuration.configure_app(dbmigrate: false, cron: false) }
    context 'in DEV environment' do
      before(:each) do
        PuppetHerald.environment = :development
      end
      it 'executes properlly' do
        expect(subject).to be_nil
      end
      it 'sets logger level to DEBUG' do
        expect(ActiveRecord::Base.logger.level).to be(Logger::DEBUG)
      end
    end
    context 'in PROD environment' do
      before(:each) do
        PuppetHerald.environment = :production
      end
      it 'executes properlly' do
        expect(subject).to be_nil
      end
      it 'sets logger level to WARN' do
        expect(ActiveRecord::Base.logger.level).to be(Logger::WARN)
      end
    end
  end
end