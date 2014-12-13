require 'spec_helper'
require 'puppet-herald'
require 'puppet-herald/version'

describe PuppetHerald, '.version_prep' do
  context 'on stable version v1.2.3' do
    subject { PuppetHerald::version_prep '1.2.3' }
    it { subject.should eq '1.2.3' }
  end
  context 'on unstable version v1.2.3.pre' do
    subject { PuppetHerald::version_prep '1.2.3.pre' }
    it { subject.should match /^1\.2\.3\.pre\.v\d+\.\d+\.\d+(?:\.\d+\.g[0-9a-f]{7}(?:\.dirty)?)?$/ }
  end
end