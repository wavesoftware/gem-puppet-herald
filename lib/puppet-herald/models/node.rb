# A module for Herald
module PuppetHerald
  # module for models
  module Models
    # A node model
    class Node < ActiveRecord::Base
      has_many :reports, dependent: :delete_all

      # Gets a node with prefetched reports
      # @param id [Integer] a in of node to get
      # @return [Node, nil] fetched node or nil
      def self.get_with_reports(id)
        Node.joins(:reports).includes(:reports).find_by_id(id)
      end
    end
  end
end
