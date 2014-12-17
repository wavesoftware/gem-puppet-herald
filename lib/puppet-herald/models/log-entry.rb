# A module for Herald
module PuppetHerald
  # module for models
  module Models
    # A log entry model
    class LogEntry < ActiveRecord::Base
      belongs_to :report
    end
  end
end
