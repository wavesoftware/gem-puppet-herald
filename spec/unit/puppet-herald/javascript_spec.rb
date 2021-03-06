require 'spec_helper'
require 'puppet-herald'
require 'puppet-herald/javascript'

describe PuppetHerald::Javascript, '.files' do
  subject { PuppetHerald::Javascript.new }
  context 'running in dev environment' do
    before :each do
      expect(PuppetHerald).to receive(:in_dev?).twice.and_return true
      expect(Dir).to receive(:glob).twice.and_return(['aaa.js', 'a/bbb.js', 'ccc_test.js'])
      subject.files
    end
    let(:files) { subject.files }
    it { files.size.should eq 2 }
    it { files.should include 'aaa.js' }
    it { files.should_not include 'ccc_test.js' }
  end

  context 'running in prod environment' do
    before :each do
      expect(PuppetHerald).to receive(:in_dev?).twice.and_return false
      expect(Dir).to receive(:glob).once.and_return(['aaa.js', 'a/bbb.js', 'ccc_test.js'])
      subject.files
    end
    let(:files) { subject.files }
    it { files.size.should eq 2 }
    it { files.should include 'aaa.js' }
    it { files.should_not include 'ccc_test.js' }
  end
end

describe PuppetHerald::Javascript, '.uglify' do
  subject { PuppetHerald::Javascript.new.uglify 'myapp.js.map' }

  it { subject.size.should eq 2 }
  it { subject['js'].should_not be_empty }
  it { subject['js.map'].should_not be_empty }
  it { subject['js'].should include('myapp.js.map') }
end