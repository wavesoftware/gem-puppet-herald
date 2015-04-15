# A module for Herald
module PuppetHerald
  # module for models
  module Models
    # Pagianation object
    class Pagination
      # Pagination headers
      KEYS = {
        page: 'X-Paginate-Page',
        limit: 'X-Paginate-Limit',
        total: 'X-Paginate-Elements',
        pages: 'X-Paginate-Pages'
      }
      # Pagination attribute limit
      # @return [Integer] pagination
      attr_reader :page, :limit, :pages, :total
      # Pagination attribute offset
      # @return [Integer] pagination
      def offset
        (page - 1) * limit
      end
      # Sets a total elements for pagination
      # @param total [Integer] a total number of elements
      # @return [nil]
      def total=(total)
        @total = total.to_i
        @pages = (@total / @limit.to_f).ceil
        nil
      end
      # A constructor
      #
      # @param page [Integer] page to fetch
      # @param limit [Integer] pagination limit
      def initialize(page, limit)
        msg = 'Invalid value for pagination'
        fail ArgumentError, "#{msg} limit - #{limit.inspect}" unless limit.to_i >= 1
        fail ArgumentError, "#{msg} page #{page.inspect}" if page.to_i < 1
        @limit = limit.to_i
        @page = page.to_i
        @total = nil
        @pages = nil
      end
      # A default pagination settings
      DEFAULT = PuppetHerald::Models::Pagination.new(1, 20)
    end
  end
end
