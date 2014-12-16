require 'puppet-herald/models/log-entry'
require 'puppet-herald/models/node'
require 'puppet-herald/stubs/puppet'

module PuppetHerald::Models

class Report < ActiveRecord::Base
  belongs_to :node
  has_many   :log_entries, dependent: :delete_all

  def self.get_with_log_entries id
    Report.where("id = ?", id).includes(:log_entries).first
  end

  def self.create_from_yaml yaml
    parsed = parse_yaml yaml
    report = Report.new
    
    parse_properties parsed, report
    parse_logs parsed, report
    node = parse_node parsed, report

    report.save
    node.save
    return report
  end

  private

  def self.parse_node parsed, report
    node = Node.find_by_name(parsed.host)
    if node.nil?
      node = Node.new
      node.name = parsed.host
      node.no_of_reports = 0
    end 
    report.node = node
    node.reports << report
    node.no_of_reports += 1
    node.status = parsed.status
    node.last_run = parsed.time
    return node
  end

  def self.parse_properties parsed, report
    attr_to_copy = [
      'status', 'environment', 
      'transaction_uuid', 'time', 
      'puppet_version', 'kind', 
      'host', 'configuration_version'
    ]
    copy_attrs parsed, report, attr_to_copy
  end

  def self.parse_logs parsed, report
    parsed.logs.each do |in_log|
      log = LogEntry.new
      attr_to_copy = [
        'level', 'message', 
        'source', 'time'
      ]
      copy_attrs in_log, log, attr_to_copy
      log.report = report
      report.log_entries << log
    end
  end

  def self.parse_yaml yaml
    require 'yaml'
    raw = YAML.parse yaml
    raw.to_ruby
  end

  def self.copy_attrs from, to, attrs
    attrs.each do |at|
      value = from.send at
      to.send "#{at}=", value
    end
  end
end

end