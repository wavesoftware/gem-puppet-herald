# A module for Herald
module PuppetHerald
  # A cron job for Herald
  class PurgeCronJob
    # Number of seconds in a day
    #
    # @return [Integer]
    SECONDS_IN_DAY = 86_400

    # Run a purge job
    #
    # @return [nil]
    def run!
      require 'puppet-herald'
      require 'puppet-herald/models/report'
      limit = ENV['PUPPET_HERALD_PURGE_LIMIT'] || '90d'
      date = parse_limit limit
      PuppetHerald.logger.info "Running a purge reports job with limit: `#{limit}` that is `#{date}`..."
      reports = PuppetHerald::Models::Report.purge_older_then(date)
      PuppetHerald.logger.info "Job completed. Purged: #{reports} reports."
      nil
    end

    # Parse a limit and returns number of seconds
    #
    # @param limit [String] a limit as string
    # @return [DateTime] a date in the past - now minus limit
    def parse_limit(limit)
      require 'rufus/scheduler'
      seconds = Rufus::Scheduler.parse limit
      now = DateTime.now
      now - Rational(seconds, SECONDS_IN_DAY)
    end
  end
end
