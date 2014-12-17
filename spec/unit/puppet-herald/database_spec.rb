require 'spec_helper'
require 'puppet-herald'

describe PuppetHerald::Database, '.spec' do
  let(:tempdir) { Dir.tmpdir }
  let(:echo) { false }
  subject { PuppetHerald::database::spec echo }
  context 'with invalid dbconn' do
    before :each do
      PuppetHerald::database::dbconn = "#{tempdir}/non-existing.db"
    end
    it { expect { subject }.to raise_error(RuntimeError, /Invalid database connection string given/) }
  end
  context 'using sqlite' do
    context 'with non existing database' do
      before :each do
        PuppetHerald::database::dbconn = 'sqlite:///non-existing/non-existing.db'
      end
      it { expect { subject }.to raise_error(Errno::ENOENT, /No such file or directory/) }
    end
    context 'with creatable database file' do
      before :each do
        PuppetHerald::database::dbconn = "sqlite://#{tempdir}/non-existing.db"
      end
      its(:class) { should be Hash }
      its(:size) { should eq 2 }
      context 'while echoing!!' do
        let(:echo) { true }
        before :each do
          PuppetHerald::database::logger.level = Logger::FATAL
        end
        its(:class) { should be Hash }
        its(:size) { should eq 2 }
      end
    end
  end
  context 'using postgres' do
    before :each do
      PuppetHerald::database::dbconn = "postgres://abc@localhost:6543/adb"
    end
    context 'with non existing passfile' do
      before :each do
        PuppetHerald::database::passfile = "/non-existing/passfile"
      end
      it { expect { subject }.to raise_error(Errno::ENOENT, /No such file or directory/) }
    end
    context 'with existing passfile' do
      before :each do
        PuppetHerald::database::passfile = __FILE__
      end
      its(:class) { should be Hash }
      its(:size) { should eq 7 }
    end
  end

end