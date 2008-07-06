require File.dirname(__FILE__) << "/config_parser"

module Brigit
  
  class GitosisAdmin
    
    attr_reader :profile
    attr_accessor :location
    def initialize(profile)
      @profile = profile
    end
    
    def config
      @config ||= config_parser.parse(File.readlines(config_file))
    end
    
    def repositories
      @repositories ||= begin
        update
        names = config.values.inject([]) { |list, section|
          list.push(*tokenize(section['writable']))
          list.push(*tokenize(section['readonly']))
        }.uniq.sort - %w(gitosis-admin gitosis)
        names.inject({}) { |all, name| all[name] = location_of(name); all }
      end
    end
    
    #######
    private
    #######
    
    def location_of(path)
      location.sub(/:.*?$/, ":#{path}")
    end
    
    def update
      if File.directory?(path) 
        Dir.chdir(path) { `git pull` } if ENV['UPDATE_GITOSIS']
      else
        check_location!
        `git clone '#{location}' '#{path}'`
      end
    end
    
    def check_location!
      unless location
        raise ArgumentError, "gitosis_admin.location not configured for profile"
      end
    end
    
    def tokenize(value)
      return [] unless value
      value.strip.split(/\s+/s)
    end
    
    def config_parser
      @config_parser ||= ConfigParser.new
    end
    
    def config_file
      File.join(path, 'gitosis.conf')
    end
    
    def path
      @path ||= profile.path_for 'gitosis-admin'
    end
    
  end
  
end
  
  
  