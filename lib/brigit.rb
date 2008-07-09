require 'find'

module Brigit
  
  def self.at_dot_gitmodules(base = Dir.pwd)
    Find.find(base) do |path|
      if File.basename(path) == '.git' && File.directory?(path)
        Find.prune
      elsif File.file?(File.join(path, '.gitmodules'))
        Dir.chdir path do
          yield path
        end
      end
    end
  end
  
  # Note: Doesn't validate against .gitmodules or .git/config
  def self.parent_of(path)
    components = path.split(File::SEPARATOR)
    components.pop
    matched = []
    components.inject(['']) do |list, component|
      list << component
      check_path = File.join(*list.clone.push('.git'))
      matched << File.dirname(check_path) if File.exists?(check_path)
      list
    end
    matched.pop
  end
  
  def self.submodule?(path)
    parent_of(path)
  end
  
  def self.at_repos(submodules = false, base = Dir.pwd)
    Find.find(base) do |path|
      if File.basename(path) == '.git' && File.directory?(path)
        Find.prune
      elsif File.directory?(File.join(path, '.git'))
        Dir.chdir path do
          yield path
        end
        Find.prune unless submodules
      end
    end
  end
    
end

$:.unshift File.dirname(__FILE__)
  
# Require all files
Dir[File.dirname(__FILE__) << "/**/*.rb"].each do |file|
  require file
end