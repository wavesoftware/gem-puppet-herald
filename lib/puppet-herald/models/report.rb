require 'puppet-herald/models/log-entry'
require 'puppet-herald/models/node'
require 'puppet-herald/stubs/puppet'
require 'sinatra/activerecord'

# A module for Herald
module PuppetHerald
  # module for models
  module Models
    # A model for Report
    class Report < ActiveRecord::Base
      belongs_to :node
      has_many :log_entries, dependent: :delete_all

      class << self
        # Gets a report with prefetched log entries
        # @param id [Integer] a in of report to get
        # @return [Report, nil] fetched report or nil
        def with_log_entries(id)
          Report.joins(:log_entries).includes(:log_entries).find_by_id(id)
        end

        # Creates a report from given YAML report file
        # @param yaml [String] a puppet report YAML as string
        # @return [Report] created report
        def create_from_yaml(yaml)
          parsed = parse_yaml yaml
          report = nil
          transaction do
            report = Report.new

            parse_properties parsed, report
            parse_logs parsed, report
            node = parse_node parsed, report

            report.save
            node.save
          end
          report
        end

        # Purges older reports then given date
        #
        # @param date [DateTime] a date that will be border to
        # @return [Integer] number of
        def purge_older_then(date)
          deleted = 0
          query = ['"reports"."time" < ?', date]
          return 0 if where(query).count == 0
          transaction do
            idss = joins(:log_entries).where(query).collect(&:id).uniq
            PuppetHerald::Models::LogEntry.where(['"report_id" IN (?)', idss]).delete_all unless idss.empty?
            where(['"id" IN (?)', idss]).delete_all unless idss.empty?
            PuppetHerald::Models::Node.delete_empty
            deleted = idss.length
          end
          deleted
        end

        private

        def parse_node(parsed, report)
          node = Node.find_by_name(parsed.host)
          if node.nil?
            node = Node.new
            node.name = parsed.host
          end
          report.node = node
          node.reports << report
          node.status = parsed.status
          node.last_run = parsed.time
          node
        end

        def parse_properties(parsed, report)
          attr_to_copy = %w(status environment transaction_uuid time puppet_version kind host configuration_version)
          copy_attrs parsed, report, attr_to_copy
        end

        def parse_logs(parsed, report)
          parsed.logs.each do |in_log|
            log = LogEntry.new
            attr_to_copy = %w(level message source time)
            copy_attrs in_log, log, attr_to_copy
            if log.message.include?('(noop)') && report.status != 'failed'
              report.status = 'pending'
              parsed.status = 'pending'
            end
            log.report = report
            report.log_entries << log
          end
        end

        def parse_yaml(yaml)
          require 'yaml'
          raw = YAML.parse yaml
          raw.to_ruby
        end

        def copy_attrs(from, to, attrs)
          attrs.each do |at|
            value = from.send at
            to.send "#{at}=", value
          end
        end
      end
    end
  end
end
