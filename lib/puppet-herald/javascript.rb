# A module for Herald
module PuppetHerald
  # A javascript processing class
  class Javascript
    # Initialize JS class
    def initialize
      @files = nil
      @base = 'lib/puppet-herald/public'
      begin
        require 'uglifier'
        @supports = true
      rescue ::StandardError => ex
        PuppetHerald.errlogger.warn("Cant find Javascript engine. Ugifing of JS app is disabled!!! Please install one of Javascript engines for ex.: gem install therubyracer (consult README.md file) - #{ex.message}")
        @supports = false
      end
    end

    # Checks if app properly supports uglifing JS
    # @return [Boolean] true, if supports
    def supports?
      @supports
    end

    # Returns a list of JS files to be inserted into main HTML
    # @return [Array] list of JS's
    def files
      require 'puppet-herald'
      @files = nil if PuppetHerald.in_dev?
      if @files.nil?
        public_dir = PuppetHerald.relative_dir(@base)
        all = Dir.chdir(public_dir) { Dir.glob('**/*.js') }
        all = all.reverse.reject { |file| file.match(/_test\.js$/) }
        @files = all.reject { |file| file.match(/bower_components/) }
      end
      @files
    end

    # Uglify an application JS's into one minified JS file
    # @param mapname [String] name of source map to be put into uglified JS
    # @return [Hash] a hash with uglified JS and source map
    def uglify(mapname)
      filenames = files
      sources = filenames.collect { |file| File.read(PuppetHerald.relative_dir("#{@base}/#{file}")) }
      source = sources.join "\n"
      options = {
        source_map_url:  mapname,
        source_filename: filenames[0],
        compress: {
          angular:    true,
          hoist_vars: true
        }
      }
      uglifier = Uglifier.new(options)
      uglified, source_map = uglifier.compile_with_map(source)
      { 'js' => uglified, 'js.map' => source_map }
    end
  end
end
