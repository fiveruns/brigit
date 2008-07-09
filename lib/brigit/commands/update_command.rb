require 'brigit/commands/command'
require 'find'

module Brigit
  
  class UpdateCommand < Command
        
    def run
      super
      Brigit.at_dot_gitmodules do |path|
        system "git submodule init"
        system "git submodule update"
      end
    end
    
  end
  
end