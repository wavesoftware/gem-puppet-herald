require 'model_helper'
require 'puppet-herald/models/report'
require 'puppet-herald/models/log-entry'
require 'puppet-herald/models/node'
require 'puppet-herald/models'

describe PuppetHerald::Models::Node, '.with_reports', :rollback => true do
  let(:yaml) { File.read(File.expand_path("../../fixtures/changed-notify.yaml", __FILE__)) }
  let(:id)   { PuppetHerald::Models::Report.create_from_yaml(yaml).node_id }

  context 'fetching an existing node' do
    subject { PuppetHerald::Models::Node.with_reports id }
    
    it "should return value that isn't nil" do
      subject.should_not be_nil
    end
    it "should return a report object" do
      subject.class.should eq(PuppetHerald::Models::Node)
    end
    it "should return persisted node" do
      subject.persisted?.should be_falsy
    end
    it "should have status 'changed'" do
      subject.status.should eq('changed')
    end
  end

  context 'paginating nodes' do
    let(:pagination) { PuppetHerald::Models::Pagination.new(1, 10) }
    subject { PuppetHerald::Models::Node.paginate(pagination) }
    it "should return value that isn't nil" do
      expect(subject).to_not be_nil
    end
  end
end