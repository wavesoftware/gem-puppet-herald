require 'model_helper'
require 'puppet-herald/models/report'
require 'puppet-herald/models/log-entry'

describe Report, ".create_from_yaml", :rollback => true do
  context 'for valid YAML' do
    let(:yaml) { File.read(File.expand_path("../../fixtures/changed-notify.yaml", __FILE__)) }
    it 'that is really not empty' do
      yaml.should_not be_empty
    end
    context 'running on real sqlite3 db' do
      subject { Report.create_from_yaml yaml }
      it "should return value that isn't nil" do
        subject.should_not be_nil
      end
      it "should return a report object" do
        subject.class.should eq(Report)
      end
      it "should return persisted report" do
        subject.persisted?.should be_truthy
      end
      it "should have status 'changed'" do
        subject.status.should eq('changed')
      end
      it "should have 3 log entries, also persisted" do
        subject.log_entries.size.should eq(3)
        subject.log_entries.each do |log|
          log.persisted?.should be_truthy
        end
      end
      it "should have parent node, that is persistedand has status 'changed'" do
        subject.node.should_not be_nil
        subject.node.status.should eq('changed')
        subject.node.persisted?.should be_truthy
      end
    end
  end
end

describe Report, '.get_with_log_entries', :rollback => true do
  let(:yaml) { File.read(File.expand_path("../../fixtures/changed-notify.yaml", __FILE__)) }
  let(:id)   { Report.create_from_yaml(yaml).id }

  context 'fetching an existing report' do
    subject { Report.get_with_log_entries id }
    
    it "should return value that isn't nil" do
      subject.should_not be_nil
    end
    it "should return a report object" do
      subject.class.should eq(Report)
    end
    it "should return persisted report" do
      subject.persisted?.should be_truthy
    end
    it "should have status 'changed'" do
      subject.status.should eq('changed')
    end
    it "should have 3 log entries, also persisted" do
      subject.log_entries.size.should eq(3)
      subject.log_entries.each do |log|
        log.persisted?.should be_truthy
      end
    end
    it "should have parent node, that is persistedand has status 'changed'" do
      subject.node.should_not be_nil
      subject.node.status.should eq('changed')
      subject.node.persisted?.should be_truthy
    end
  end
end