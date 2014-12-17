require 'spec_helper'
require 'puppet-herald'

describe PuppetHerald, '.relative_dir' do
  let(:thisfile) { File.realpath(__FILE__) }
  context 'on directory "."' do
    subject { PuppetHerald.relative_dir '.' }

    it do
      subject.should_not be_nil
    end

    it 'should give a common path' do
      thisfile.should include(subject)
    end

    it do
      thisfile.gsub(subject, '').should eq('/spec/unit/puppet-herald_spec.rb')
    end
  end

  context 'on directory "lib/puppet-herald/public"' do
    subject { PuppetHerald.relative_dir 'lib/puppet-herald/public' }

    it { Pathname.new(File.join(subject, 'app.js')).should be_file }
  end
end

describe PuppetHerald do
  after :each do
    ENV.delete 'PUPPET_HERALD_ENV'
  end
  context 'on unset environment variable' do
    before :each do
      ENV.delete 'PUPPET_HERALD_ENV'
    end
    describe '.environment' do
      it { subject::environment.should eq(:production) }
    end
    describe '.in_prod?' do
      it { subject.should be_in_prod }
    end
  end

  context 'on environment variable set to dev' do
    before :each do
      ENV['PUPPET_HERALD_ENV'] = 'dev'
    end
    describe '.environment' do
      it { subject::environment.should eq(:dev) }
    end
    describe '.in_prod?' do
      it { subject.should be_in_dev }
    end
  end
end