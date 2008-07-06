# Require all files

Dir[File.dirname(__FILE__) << "/**/*.rb"].each do |file|
  require file
end

module Brigit
  
  def self.profile(name = nil, &block)
    if (profile = profiles[name])
      profile.instance_eval(&block)
      profiles[name] = profile
      profile
    else
      profiles[name] = Profile.new(name, &block)
    end
  end
  class << self; alias config profile; end
  
  def self.profiles
    @profiles ||= Hash.new { |_, name| Profile.new(name) }
  end
  
  def self.default_profile
    profiles[nil]
  end
  
  def self.load_profiles
    if File.exists?(config_file)
      eval File.read(config_file)
    end
  end
  
  def self.config_file
    @config_file ||= File.expand_path("~/.brigitrc")
  end
  
  def self.repos_under_pwd
    @repos_under_pwd ||= begin
      repos = []
      base = Dir.pwd
      Find.find(Dir.pwd) do |path|
        if File.directory?(path) && File.directory?(File.join(path, '.git'))
          repos << path[(base.size + 1)..-1]
          Find.prune
        end
      end
      repos
    end
  end
  
end
  