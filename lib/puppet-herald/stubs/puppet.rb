module Puppet
  module Transaction

    class Report
      attr_accessor :host, :time, :kind, :puppet_version, :configuration_version, :transaction_uuid, :environment, :status, :logs
    end

    class Event

    end

  end
  class Resource
    class Status

    end
  end
  module Util

    class Log
      attr_accessor :level, :message, :source, :time, :line, :tags
    end

    class Metric

    end

  end
end