module PuppetHerald::Models
  class LogEntry < ActiveRecord::Base
    belongs_to :report
  end
end
