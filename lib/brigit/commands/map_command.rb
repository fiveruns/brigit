require File.dirname(__FILE__) << "/command"
require 'find'

module Brigit
  
  class MapCommand < Command
    
    self.help = "Create a DOT file showing submodules"
    
    def execute!
      Brigit.repos_under_pwd.each do |path|
        Dir[File.join(path, '**/.gitmodules')].each do |gitmodules|
          puts File.read(gitmodules)
          p parser.parse(File.readlines(gitmodules))
        end
      end
    end
    
    #######
    private
    #######
    
    def parser
      @parser ||= ConfigParser.new
    end
      
  end
  
end