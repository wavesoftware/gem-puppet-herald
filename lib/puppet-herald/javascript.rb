# A module for Herald
module PuppetHerald
  # A javascript processing class
  class Javascript
    # Initialize JS class
    def initialize
      @files = nil
      @base = 'lib/puppet-herald/public'
    end

    # Gets a Javascript project main dependencies
    # @param in_public [Boolean] if true, will return a short form for public
    # @return [Array] a list of dependencies
    def main_deps(in_public = true)
      deps = javascript_project['dependencies']
      deps.collect! { |x| x.gsub("#{@base}/", '') } if in_public
      deps
    end

    # Gets a Javascript project development dependencies
    # @return [Array] a list of development dependencies
    def dev_deps
      javascript_project['devDependencies']
    end

    # Gets a Javascript all project dependencies
    # @return [Array] a list of dependencies
    def deps
      main_deps(in_public: false).concat(dev_deps)
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
      require 'uglifier'
      sources = files.collect { |file| File.read("#{@base}/#{file}") }
      source = sources.join "\n"
      uglifier = Uglifier.new(source_map_url: mapname)
      uglified, source_map = uglifier.compile_with_map(source)
      {
        'js'     => uglified,
        'js.map' => source_map
      }
    end

    private

    def javascript_project
      require 'json'
      require 'tmpdir'
      public_dir = Pathname.new(__FILE__).dirname.join('public')
      dir = public_dir.dirname
      jsproject_path = dir.join 'project'
      digest = make_digest(public_dir)
      hfile = Pathname.new(Dir.tmpdir).join("puppet-herald-dev-bower-#{digest}.deps")
      unless hfile.file?
        file = Tempfile.new('puppet-herald-dev')
        file.write "var project = require('#{jsproject_path}'); process.stdout.write(JSON.stringify(project));"
        file.close
        jsons = `node #{file.path}`
        file.unlink
        json = JSON.parse(jsons).select { |key| %w(dependencies devDependencies).include? key }
        jsons = json.to_json
        hfile.open(mode: 'w+') { |f| f.write jsons }
      end
      JSON.parse(hfile.read)
    end

    def make_digest(dir)
      parent = dir.dirname
      jsproject = parent.join 'project.js'
      bower = dir.join 'bower.json'
      hash = Digest::MD5.new
      hash.update(jsproject.read)
      hash.update(bower.read)
      digest = hash.hexdigest
    end
  end
end
