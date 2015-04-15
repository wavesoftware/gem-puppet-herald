require 'model_helper'
require 'puppet-herald/models/report'
require 'puppet-herald/models/log-entry'

describe PuppetHerald::Models::Report, ".create_from_yaml", :rollback => true do
  context 'for `changed` status report' do
    let(:yaml) { File.read(File.expand_path("../../fixtures/changed-notify.yaml", __FILE__)) }
    it 'that is really not empty' do
      yaml.should_not be_empty
    end
    context 'running on real sqlite3 db' do
      subject { PuppetHerald::Models::Report.create_from_yaml yaml }
      it "should return value that isn't nil" do
        subject.should_not be_nil
      end
      it "should return a report object" do
        subject.class.should eq(PuppetHerald::Models::Report)
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
      it "should have parent node, that is persisted and has status 'changed'" do
        subject.node.should_not be_nil
        subject.node.status.should eq('changed')
        subject.node.persisted?.should be_truthy
      end
    end
  end
  context 'for `pending` status report' do
    let(:yaml) { File.read(File.expand_path("../../fixtures/pending-notify.yaml", __FILE__)) }
    it 'that is really not empty' do
      expect(yaml).to_not be_empty
    end
    context 'running on real sqlite3 db' do
      subject { PuppetHerald::Models::Report.create_from_yaml yaml }
      it "should return value that isn't nil" do
        subject.should_not be_nil
      end
      it "should return a report object" do
        subject.class.should eq(PuppetHerald::Models::Report)
      end
      it "should return persisted report" do
        subject.persisted?.should be_truthy
      end
      it "should have status 'pending'" do
        subject.status.should eq('pending')
      end
      it "should have 11 log entries, also persisted" do
        subject.log_entries.size.should eq(11)
        subject.log_entries.each do |log|
          log.persisted?.should be_truthy
        end
      end
      it "should have parent node, that is persisted and has status 'pending'" do
        subject.node.should_not be_nil
        subject.node.status.should eq('pending')
        subject.node.persisted?.should be_truthy
      end
    end
  end
end

describe PuppetHerald::Models::Report, '.with_log_entries', :rollback => true do
  let(:yaml) { File.read(File.expand_path("../../fixtures/changed-notify.yaml", __FILE__)) }
  let(:id)   { PuppetHerald::Models::Report.create_from_yaml(yaml).id }

  context 'fetching an existing report' do
    subject { PuppetHerald::Models::Report.with_log_entries id }
    
    it "should return value that isn't nil" do
      subject.should_not be_nil
    end
    it "should return a report object" do
      subject.class.should eq(PuppetHerald::Models::Report)
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

describe PuppetHerald::Models::Report, '.purge_older_then', :rollback => true do
  let(:yaml1) { File.read(File.expand_path("../../fixtures/changed-notify.yaml", __FILE__)) }
  let(:yaml2) { File.read(File.expand_path("../../fixtures/pending-notify.yaml", __FILE__)) }
  let(:date) { DateTime.new(2015, 4, 8, 14, 20, 0, '+2') }
  before(:each) do
    PuppetHerald::Models::LogEntry.delete_all
    PuppetHerald::Models::Report.delete_all
    PuppetHerald::Models::Node.delete_all
    PuppetHerald::Models::Report.create_from_yaml(yaml1)
    PuppetHerald::Models::Report.create_from_yaml(yaml1)
    PuppetHerald::Models::Report.create_from_yaml(yaml2)
  end
  subject { PuppetHerald::Models::Report.purge_older_then(date) }
  context 'running on real sqlite3 db with date `2015-04-08 14:20:00+0200`' do
    it 'return `2` as a number of a reports purged' do
      expect(PuppetHerald::Models::Node.count).to eq(1)
      expect(PuppetHerald::Models::Report.count).to eq(3)
      expect(subject).to eq(2)
      expect(PuppetHerald::Models::Report.count).to eq(1)
      expect(PuppetHerald::Models::Node.count).to eq(1)
    end
  end
end