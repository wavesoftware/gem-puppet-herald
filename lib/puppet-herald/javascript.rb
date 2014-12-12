require 'puppet-herald'

module PuppetHerald
  class Javascript

    @@files = nil

    def self.files
      if PuppetHerald::is_in_dev?
        @@files = nil
      end
      if @@files.nil?
        public_dir = PuppetHerald::relative_dir('lib/puppet-herald/public')
        all = Dir.chdir(public_dir) { Dir.glob('**/*.js') }
        @@files = all.reverse.reject { |file| file.match(/_test\.js$/) }
      end
      return @@files
    end
  end
end