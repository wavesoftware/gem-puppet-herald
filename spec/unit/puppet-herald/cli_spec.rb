require 'spec_helper'
require 'puppet-herald'
require 'puppet-herald/cli'

context 'With silenced loggers' do

  before :each do
    PuppetHerald::CLI::logger.level = 100
    PuppetHerald::CLI::errlogger.level = 100
    PuppetHerald::Database::logger.level = 100
    PuppetHerald::Database::dbconn = nil
  end

  describe PuppetHerald::CLI, '.parse_options' do
    subject { PuppetHerald::CLI::parse_options argv }

    context 'on defaults' do
      let(:argv) { [] }
      its(:class) { should be Hash }
      it { subject[:port].should eq 11303 }
    end

    context 'on with invalid DB' do
      let(:argv) { ['--dbconn', '/non-exist/db.sqlite'] }
      
      it { expect { subject }.to raise_error(RuntimeError, /Invalid database connection string given/) }
    end
  end

  describe PuppetHerald::CLI, '.run!' do
    subject { PuppetHerald::CLI::run! argv }

    context 'on defaults' do
      let(:argv) { [] }
      before :each do
        require 'puppet-herald/app'
        expect(Kernel).to receive(:exit).with(0)
        expect(PuppetHerald::App).to receive(:run!).and_return :none
      end

      it { expect(subject).to be_nil }
    end

    context 'on with invalid DB' do
      let(:argv) { ['--dbconn', '/non-exist/db.sqlite'] }
      before :each do
        expect(Kernel).to receive(:exit).with(2)
      end
      
      it { expect(subject).to be_nil }
    end
  end

end