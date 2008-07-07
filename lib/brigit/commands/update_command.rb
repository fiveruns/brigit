require File.dirname(__FILE__) << "/command"
require 'find'

module Brigit
  
  class UpdateCommand < Command
    
    self.help = "Update all submodules in the repo, recursively"
    
    def execute!
      super
      Brigit.at_dot_gitmodules do |path|
        system "git submodule init"
        system "git submodule update"
      end
    end
    
  end
  
end