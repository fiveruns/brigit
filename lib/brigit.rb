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
  
  def self.at_repos(base = Dir.pwd)
    Find.find(base) do |path|
      if File.basename(path) == '.git' && File.directory?(path)
        Find.prune
      elsif File.directory?(File.join(path, '.git'))
        Dir.chdir path do
          yield path
        end
        Find.prune
      end
    end
  end
    
end

$:.unshift File.dirname(__FILE__)
  
# Require all files
Dir[File.dirname(__FILE__) << "/**/*.rb"].each do |file|
  require file
end