# A stub Puppet module
module Puppet
  # A stub Puppet module
  module Transaction
    # A stub Puppet class
    class Report
      # A puppet variable from report
      # @return [String] a puppet set variable
      attr_accessor :host, :time, :kind, :puppet_version, :configuration_version

      # A puppet variable from report
      # @return [String] a puppet set variable
      attr_accessor :transaction_uuid, :environment, :status, :logs
    end

    # A stub Puppet class
    class Event
    end
  end

  # A stub Puppet class
  class Resource
    # A stub Puppet class
    class Status
    end
  end
  # A stub Puppet module
  module Util
    # A stub Puppet class
    class Log
      # A puppet variable from report
      # @return [String] a puppet set variable
      attr_accessor :level, :message, :source, :time, :line, :tags
    end

    # A stub Puppet class
    class Metric
    end
  end
end
