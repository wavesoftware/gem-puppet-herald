require 'puppet-herald/models'
require 'puppet-herald/models/report'
require 'sinatra/activerecord'

# A module for Herald
module PuppetHerald
  # module for models
  module Models
    # A node model
    class Node < ActiveRecord::Base
      has_many :reports, dependent: :delete_all

      # Paginete thru nodes reports
      #
      # @param pagination [PuppetHerald::Models::Pagination] a pagination
      # @return [Node] fetched node
      def paginate_reports(pagination)
        pagination.total = no_of_reports
        paginated = reports.order(time: :desc).limit(pagination.limit)
                    .offset(pagination.offset)
        duplicate = dup
        duplicate.reports = paginated
        duplicate.id = id
        duplicate.readonly!
        duplicate
      end

      # Gets number of reports for node
      #
      # @return [Integer] number of node's reports
      def no_of_reports
        PuppetHerald::Models::Report.where(node_id: id).count
      end

      # Deletes nodes that doesn't have reports
      #
      # @return [Integer] number of empty node deleted
      def self.delete_empty
        joinsql = 'LEFT JOIN "reports" ON "reports"."node_id" = "nodes"."id"'
        wheresql = '"reports"."node_id" IS NULL'
        joins(joinsql).where(wheresql).delete_all if joins(joinsql).where(wheresql).count > 0
      end

      # Gets a node with prefetched reports
      #
      # @param id [Integer] a in of node to get
      # @param pagination [PuppetHerald::Models::Pagination] a pagination
      # @return [Node, nil] fetched node or nil
      def self.with_reports(id, pagination = PuppetHerald::Models::Pagination::DEFAULT)
        node = find_by_id(id)
        node.paginate_reports pagination unless node.nil?
      end

      # Gets a paginated nodes
      #
      # @param pagination [PuppetHerald::Models::Pagination] a pagination
      # @return [Node[]] nodes
      def self.paginate(pagination)
        pagination.total = count
        order(last_run: :desc).limit(pagination.limit).offset(pagination.offset)
      end
    end
  end
end
