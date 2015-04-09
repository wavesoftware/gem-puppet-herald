require 'puppet-herald/purgecronjob'

describe PuppetHerald::PurgeCronJob do
  let(:job) { PuppetHerald::PurgeCronJob.new }
  let(:now) { DateTime.new(2015,4,9,20,3,2,'+2') }
  let(:minus30d) { DateTime.new(2015,3,10,20,3,2,'+2') }
  let(:minus45d) { DateTime.new(2015,2,23,20,3,2,'+2') }
  before(:each) do
    expect(DateTime).to receive(:now).and_return(now)
    ENV['PUPPET_HERALD_PURGE_CRON'] = '*/15 * * * * *'
    ENV['PUPPET_HERALD_PURGE_LIMIT'] = '45d'
  end
  describe '.parse_limit' do
    it 'with "30d" to be equal to `2015-03-10 20:03:02 +0200`' do
      expect(job.parse_limit '30d').to eq(minus30d)
    end
    it 'with "45d" to be equal to `2015-02-23 20:03:02 +0200`' do
      expect(job.parse_limit '45d').to eq(minus45d)
    end
  end
  describe '.run!' do
    level = nil
    before(:each) do
      require 'puppet-herald'
      require 'puppet-herald/models/report'
      expect(PuppetHerald::Models::Report).to receive(:purge_older_then).with(minus45d).and_return(2)
      level = PuppetHerald.logger.level
      PuppetHerald.logger.level = 100
    end
    after(:each) do
      PuppetHerald.logger.level = level
    end
    it 'executes properlly' do
      expect(job.run!).to be_nil
    end
  end
end