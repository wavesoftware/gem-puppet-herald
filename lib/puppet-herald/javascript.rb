require 'puppet-herald'
require 'uglifier'

module PuppetHerald
  class Javascript

    @@files = nil

    @@base = 'lib/puppet-herald/public'

    def self.files
      if PuppetHerald::is_in_dev?
        @@files = nil
      end
      if @@files.nil?
        public_dir = PuppetHerald::relative_dir(@@base)
        all = Dir.chdir(public_dir) { Dir.glob('**/*.js') }
        @@files = all.reverse.reject { |file| file.match(/_test\.js$/) }
      end
      return @@files
    end

    def self.uglify mapname
      sources = files.collect { |file| File.read("#{@@base}/#{file}") }
      source = sources.join "\n"
      uglifier = Uglifier.new(:source_map_url => mapname)
      uglified, source_map = uglifier.compile_with_map(source)
      return {
        'js'     => uglified,
        'js.map' => source_map
      }
    end
  end
end