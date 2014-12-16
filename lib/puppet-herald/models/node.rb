module PuppetHerald::Models
  class Node < ActiveRecord::Base
    has_many :reports, dependent: :delete_all

    def self.get_with_reports(id)
      Node.where('id = ?', id).includes(:reports).first
    end
  end
end
