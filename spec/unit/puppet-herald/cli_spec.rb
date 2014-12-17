require 'spec_helper'
require 'puppet-herald'
require 'puppet-herald/cli'
require 'sinatra/base'

class TestCLI < PuppetHerald::CLI
  def test_parse(argv)
    self.parse(argv)
  end
end

context 'With silenced loggers' do

  let(:cli) { TestCLI.new }

  before :each do
    cli.logger.level = 100
    cli.errlogger.level = 100
    PuppetHerald::database::logger.level = 100
    PuppetHerald::database::dbconn = nil
    allow(FileUtils).to receive(:touch)
  end

  describe PuppetHerald::CLI, '.parse' do
    subject { cli.test_parse argv }

    context 'on defaults' do
      let(:argv) { [] }
      its(:class) { should be Hash }
      it { subject[:port].should eq 11303 }
    end

    context 'with invalid DB configuration given' do
      let(:argv) { ['--dbconn', '/non-exist/db.sqlite'] }
      
      it { expect { subject }.to raise_error(RuntimeError, /Invalid database connection string given/) }
    end
  end

  describe PuppetHerald::CLI, '.run!' do
    subject { cli.run! argv }

    context 'on defaults' do
      let(:argv) { [] }
      before :each do
        expect(PuppetHerald).to receive(:in_dev?).at_least(:once).and_return(false)
        expect(Kernel).to receive(:exit).with(0)
        expect(Sinatra::Application).to receive(:run!).and_return :none
        dbconn = { :adapter => 'sqlite3', :database => ':memory:' }
        expect(PuppetHerald::database).to receive(:spec).at_least(:once).and_return dbconn
        require 'stringio'        # silence the output
        $stdout = StringIO.new    # from migrator
      end
      after :each do
        $stdout = STDOUT
      end

      it { expect(subject).to be_nil }
    end

    context 'with exception from within starting application' do
      let(:argv) { [] }
      before :each do
        expect(Kernel).to receive(:exit).with(1).and_raise :excpected1
        expect(ActiveRecord::Base).to receive(:establish_connection).and_raise :expected2
        dbconn = { :adapter => 'sqlite3', :database => ':memory:' }
        expect(PuppetHerald::database).to receive(:spec).at_least(:once).and_return dbconn
      end
      after :each do
        Dir.glob(Dir.tmpdir + '/puppet-herald-bug*.log') { |file| Pathname.new(file).unlink }
      end
      
      it { expect { subject }.to raise_error }
    end

    context 'with invalid DB configuration given' do
      let(:argv) { ['--dbconn', '/non-exist/db.sqlite'] }
      before :each do
        expect(Kernel).to receive(:exit).with(2).and_raise :excpected
      end
      
      it { expect { subject }.to raise_error }
    end
  end

end