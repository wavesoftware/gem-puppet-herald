require 'net/http'

# A module for Herald
module PuppetHerald
  # A client class for Herald
  class Client
    # Constructs a client
    #
    # @param host [String] a host to connect to, default to +'localhost'+
    # @param port [Integer] a port to connect to, default to +11303+
    # @return [PuppetHerald::Client] a client instance
    def initialize(host = 'localhost', port = 11_303)
      @host = host
      @port = port
      self
    end

    # Process a puppet report and sends it to Herald
    #
    # @param report [Puppet::Transaction::Report] a puppet report
    # @param block [Proc] a optional block that can modify request before sending
    # @return [Boolean] true if everything is ok
    def process(report, &block)
      path = '/api/v1/reports'
      header = { 'Content-Type' => 'application/yaml' }
      req = Net::HTTP::Post.new(path, initheader = header) # rubocop:disable all
      req.body = report.to_yaml
      block.call(req) if block
      Net::HTTP.new(@host, @port).start { |http| http.request(req) }
      true
    end
  end
end
