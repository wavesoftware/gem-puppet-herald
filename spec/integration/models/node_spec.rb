require 'model_helper'
require 'puppet-herald/models/report'
require 'puppet-herald/models/log-entry'
require 'puppet-herald/models/node'

describe Node, '.get_with_reports' do
  let(:yaml) { File.read(File.expand_path("../../fixtures/changed-notify.yaml", __FILE__)) }
  let(:id)   { Report.create_from_yaml(yaml).node_id }

  context 'fetching an existing node' do
    subject { Node.get_with_reports id }
    
    it "should return value that isn't nil" do
      subject.should_not be_nil
    end
    it "should return a report object" do
      subject.class.should eq(Node)
    end
    it "should return persisted node" do
      subject.persisted?.should be_truthy
    end
    it "should have status 'changed'" do
      subject.status.should eq('changed')
    end
  end
end